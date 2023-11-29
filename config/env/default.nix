{ pkgs, pkgs-unstable, lib, config, ... }: {
  # All my developer tooling can use nixpkgs-unstable
  home.packages = with pkgs-unstable; [
    rustup
    temurin-bin-17
    gradle
    nodejs_20
    nodePackages_latest.pnpm
    mongosh
    ldid
    gh
    awscli2
    xz
    goreleaser
    go
    cmake
    ninja
    python312
    xh

    # Language servers
    jdt-language-server
    lua-language-server
    nodePackages_latest.svelte-language-server
    nodePackages_latest.typescript-language-server
    nodePackages_latest.vscode-langservers-extracted
    nodePackages_latest.yaml-language-server
    nodePackages_latest."@astrojs/language-server"
    rnix-lsp
  ];

  programs.ssh = {
    enable = true;
    compression = true;
    controlMaster = "auto";
    controlPath = "/tmp/ssh_socket-%r@%h:%p";
    controlPersist = "60m";
    forwardAgent = true;
    includes = [
      "${config.home.homeDirectory}/.ssh/private.config"
      "${config.home.homeDirectory}/.orbstack/ssh/config"
    ];
    matchBlocks = {
      "localhost" = {
        extraOptions = {
          "StrictHostKeyChecking" = "no";
          "UserKnownHostsFile" = "/dev/null";
        };
      };

      "gh" = {
        user = "git";
        hostname = "github.com";
      };
    };
  };

  home.file = {
    ".theosrc".text = ''
      THEOS_DEVICE_IP ?= localhost
      THEOS_DEVICE_PORT ?= 2222
    '';
    ".huskyrc".text = ''
      HOOKS_DIR=$(git config --global core.hooksPath)
      HOOK_PATH="$HOOKS_DIR/$hook_name"

      # hook_name is from the husky script
      if [ -f "$HOOK_PATH" ]; then
        source "$HOOK_PATH"
      fi
    '';
  };

  home.activation = {
    installTheos = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      THEOS="$HOME/Library/Theos"
      [ -d "$THEOS" ] || $DRY_RUN_CMD ${pkgs.git}/bin/git clone --recursive https://github.com/theos/theos.git "$THEOS"
    '';
    configureRust = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      	  $DRY_RUN_CMD ${pkgs.rustup}/bin/rustup default stable
      	'';
  };
}
