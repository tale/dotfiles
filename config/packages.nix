{ lib, pkgs, unstable, config, ... }:
let
  iconFolder = "${config.home.homeDirectory}/.config/dotfiles/config/icons";
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
      iconset
      (nerdfonts.override { fonts = [ "IosevkaTerm" ]; })
      jq
      kubectl
      pam-reattach
      postgresql_jit
      ripgrep
      rsync
      wget
      zstd
    ])
    ++
    (with unstable; [
      awscli2
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
      python312
      rnix-lsp
      rustup
    ]);

  home.activation = {
    # Sudo can be hardcoded here since this runs on macOS
    #iconsetRun = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    #  $DRY_RUN_CMD /usr/bin/sudo ${iconset}/bin/iconset folder ${iconFolder}
    #'';

    dockFixup = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      $DRY_RUN_CMD ${pkgs.dockutil}/bin/dockutil --remove all --no-restart $HOME
      $DRY_RUN_CMD ${pkgs.dockutil}/bin/dockutil --add /Applications/Google\ Chrome.app --no-restart $HOME
      $DRY_RUN_CMD ${pkgs.dockutil}/bin/dockutil --add /System/Applications/Messages.app --no-restart $HOME
      $DRY_RUN_CMD ${pkgs.dockutil}/bin/dockutil --add /System/Applications/Calendar.app --no-restart $HOME
      $DRY_RUN_CMD ${pkgs.dockutil}/bin/dockutil --add /System/Applications/Mail.app --no-restart $HOME
      $DRY_RUN_CMD ${pkgs.dockutil}/bin/dockutil --add /Applications/Things3.app --no-restart $HOME
      $DRY_RUN_CMD ${pkgs.dockutil}/bin/dockutil --add /Applications/Spotify.app --no-restart $HOME
      $DRY_RUN_CMD ${pkgs.dockutil}/bin/dockutil --add '~/Downloads' --view grid --display folder --section others --no-restart $HOME
      $DRY_RUN_CMD /usr/bin/killall Dock
    '';
  };
}
