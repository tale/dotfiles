{ pkgs, ... }: {
  home.stateVersion = "23.05";
  home.username = "tale";
  home.homeDirectory = "/home/tale";

  programs.home-manager.enable = true;
  nix = {
    package = pkgs.nix;
    settings = {
      experimental-features = "nix-command flakes";
    };
  };

  services.gpg-agent = {
    enable = true;
    extraConfig = builtins.readFile ./gnupg/gpg-agent.conf;
  };

  imports = [
    ./packages.nix
    ./env
    ./zsh
    ./git
    ./gnupg
    ./nvim
    ./tui
  ];
}
