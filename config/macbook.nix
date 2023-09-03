{ pkgs, ... }: {
  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;

  homebrew = {
    enable = true;
    casks = [
      "1password"
      "alacritty"
      "aldente"
      "bartender"
      "cleanmymac"
      "datagrip"
      "discord"
      "google-chrome"
      "iina"
      "imageoptim"
      "keycastr"
      "maccy"
      "microsoft-excel"
      "microsoft-outlook"
      "microsoft-remote-desktop"
      "microsoft-teams"
      "microsoft-word"
      "minecraft"
      "monitorcontrol"
      "mullvadvpn"
      "orbstack"
      "parsec"
      "postman"
      "raycast"
      "sensei"
      "slack"
      "soulver"
      "spotify"
      "steam"
      "tailscale"
      "the-unarchiver"
      "xcodes"
      "yubico-yubikey-manager"
      "zed"
      "zoom"
      "zotero"
    ];
  };

  users.users.tale = {
    name = "tale";
    home = "/Users/tale";
  };

  programs.zsh = {
    enable = true;
    promptInit = "";
    enableCompletion = false; # Handled by local zshrc after zcompile runs
  };

  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
  home-manager.users.tale = { pkgs, ... }: {
    home.stateVersion = "23.05";

    programs.home-manager.enable = true;
    imports = [
      ./packages.nix
      ./zsh
      ./git
      ./gnupg
      ./launchd
      ./tui
    ];
  };
}
