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
      "microsoft-excel"
      "microsoft-powerpoint"
      "microsoft-word"
      "minecraft"
      "monitorcontrol"
      "orbstack"
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
