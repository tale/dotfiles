{ lib, stendv, pkgs, ... }:
let
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
in
{
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    bat
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
    exa
    fzf
    delta
    rsync
    s3cmd
    neovim
    minikube
    gnumake
    yubikey-manager
    yubikey-personalization
    tmux
    tmate
    gnutar
    coreutils
    findutils
    ripgrep
    go-task
    restic
    ldid
    libusbmuxd
    macos-trash
    temurin-bin-17
    (nerdfonts.override { fonts = [ "Mononoki" ]; })
  ];
}
