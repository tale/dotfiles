{ lib, stendv, pkgs, config, ... }:
let
  iconFolder = "${config.home.homeDirectory}/.config/dotfiles/config/icons";
  macos-trash = pkgs.stdenv.mkDerivation rec {
    pname = "macos-trash";
    version = "1.2.0";

    src = pkgs.fetchzip {
      url = "https://github.com/sindresorhus/macos-trash/releases/download/v1.2.0/trash.zip";
      sha256 = "sha256-JMbGMIy0DFLFYcyLbh7M0l60k8+w8Dgx3GianjgZTv0=";
    };

    dontPatch = true;
    dontConfigure = true;
    dontBuild = true;
    dontFixup = true;

    installPhase = ''
      mkdir -p $out/bin
      install -m 0755 trash $out/bin
    '';

    meta = {
      homepage = "https://github.com/sindresorhus/macos-trash";
      description = "Move files and folders to the trash";
      platforms = lib.platforms.darwin;
      license = lib.licenses.mit;
    };
  };

  iconset = pkgs.stdenv.mkDerivation rec {
    pname = "iconset";
    version = "1.0.0";

    src = pkgs.fetchzip {
      url = "https://github.com/tale/iconset/releases/download/v1.0.0/iconset.zip";
      sha256 = "sha256-/1Qnc3t99FQEM1/l/XtXF28rV4AnCVGtcsr2Drvvs6M=";
    };

    dontPatch = true;
    dontConfigure = true;
    dontBuild = true;
    dontFixup = true;

    installPhase = ''
      mkdir -p $out/bin
      install -m 0755 iconset $out/bin
    '';

    meta = {
      homepage = "https://github.com/tale/iconset";
      description = "A nifty command-line tool to customize macOS icons";
      platforms = lib.platforms.darwin;
      license = lib.licenses.asl20;
    };
  };
in
{
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    bat
    syncthing
    zstd
    kubectl
    kubernetes-helm
    jq
    yq
    curl
    wget
    caddy
    btop
    cmake
    fzf
    delta
    rsync
    s3cmd
    minikube
    gnumake
    tree-sitter
    yubikey-manager
    postgresql_jit
    yubikey-personalization
    gnutar
    coreutils
    fd
    findutils
    ripgrep
    go-task
    libusbmuxd
    macos-trash
    iconset
    dockutil
    rnix-lsp
    lua-language-server
    nodePackages_latest.svelte-language-server
    nodePackages_latest.vscode-langservers-extracted
    nodePackages_latest.yaml-language-server
    (nerdfonts.override { fonts = [ "Mononoki" ]; })
  ];

  # TODO: Include the application icons in this repository
  home.activation = {
    # Sudo can be hardcoded here since this runs on macOS
    iconsetRun = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      $DRY_RUN_CMD /usr/bin/sudo ${iconset}/bin/iconset folder ${iconFolder}
    '';

    dockFixup = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      $DRY_RUN_CMD ${pkgs.dockutil}/bin/dockutil --remove all --no-restart $HOME
      $DRY_RUN_CMD ${pkgs.dockutil}/bin/dockutil --add /Applications/Google\ Chrome.app --no-restart $HOME
      $DRY_RUN_CMD ${pkgs.dockutil}/bin/dockutil --add /System/Applications/Messages.app --no-restart $HOME
      $DRY_RUN_CMD ${pkgs.dockutil}/bin/dockutil --add /System/Applications/Calendar.app --no-restart $HOME
      $DRY_RUN_CMD ${pkgs.dockutil}/bin/dockutil --add /Applications/Microsoft\ Outlook.app --no-restart $HOME
      $DRY_RUN_CMD ${pkgs.dockutil}/bin/dockutil --add /Applications/Things3.app --no-restart $HOME
      $DRY_RUN_CMD ${pkgs.dockutil}/bin/dockutil --add /Applications/Spotify.app --no-restart $HOME
      $DRY_RUN_CMD ${pkgs.dockutil}/bin/dockutil --add '~/Downloads' --view grid --display folder --section others --no-restart $HOME
      $DRY_RUN_CMD /usr/bin/killall Dock
    '';
  };
}
