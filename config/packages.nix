{ lib, pkgs, unstable, config, ... }: {
  home.packages =
    (with pkgs; [
      caddy
      coreutils
      curl
      darwin.trash
      delta
      dockutil
      fd
      findutils
      fzf
      git
      gnused
      gnutar
      go-task
      gnumake
      htop
      (nerdfonts.override { fonts = [ "IosevkaTerm" ]; })
      jq
      kubectl
      pam-reattach
      postgresql_jit
      ripgrep
      rsync
      wget
      yq
      zstd
    ])
    ++
    (with unstable; [
      awscli2
      cloudflared
      cmake
      goreleaser
      go
      lua-language-server
      mongosh
      nodejs_20
      nodePackages_latest.pnpm
      nodePackages_latest.svelte-language-server
      nodePackages_latest.typescript-language-server
      nodePackages_latest.vscode-langservers-extracted
      nodePackages_latest.yaml-language-server
      ninja
      oci-cli
      python312
      rnix-lsp
      rustup
    ]);
}
