{ ... }: {
  homebrew = {
    enable = true;
    caskArgs = {
      no_quarantine = true;
    };
    masApps = {
      Things = 904280696;
    };
    taps = [
      "nikitabobko/tap"
    ];
    casks = [
      "1password"
      "aerospace"
      "alacritty"
      "aldente"
      "bartender"
      "cleanmymac"
      "cleanshot"
      "craft"
      "datagrip"
      "discord"
      "google-chrome"
      "imageoptim"
      "maccy"
      "microsoft-auto-update"
      "microsoft-excel"
      "microsoft-powerpoint"
      "microsoft-teams"
      "microsoft-word"
      "minecraft"
      "monitorcontrol"
      "orbstack"
      "plex"
      "postman"
      "soulver"
      "spotify"
      "steam"
      "syncthing"
      "tailscale"
      "xcodes"
      "zoom"
    ];
  };
}
