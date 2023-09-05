{ pkgs, ... }: {
  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;

  homebrew = {
    enable = true;
    # TODO: MAS & Things3 + Other App Store
    casks = [
      "1password"
      "alacritty"
      "aldente"
      "bartender"
      "cleanmymac"
      "craft"
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

  networking = {
    knownNetworkServices = [
      "Wi-Fi"
    ];
    dns = [
      "1.1.1.1"
      "1.0.0.1"
      "8.8.8.8"
      "8.8.4.4"
    ];
  };

  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';

    gc = {
      automatic = true;
      interval = {
        Hour = 3;
        Minute = 0;
      };
    };
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # TODO: programs.ssh & services.openssh
  programs.zsh = {
    enable = true;
    promptInit = "";
    enableCompletion = false; # Handled by local zshrc after zcompile runs
  };

  # Will reset on macOS updates
  security.pam.enableSudoTouchIdAuth = true;

  # TODO: Maybe look into services.dnsmasq? Or just do it per project
  system.defaults = {
    SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;
    dock = {
      autohide = true;
      autohide-delay = 0.0;
      autohide-time-modifier = 0.5;
      showhidden = true;
      wvous-tl-corner = 12; # Notification Center
      wvous-tr-corner = 12;
      wvous-bl-corner = 11; # Launchpad
      wvous-br-corner = 11;
    };

    finder = {
      ShowPathbar = true;
      ShowStatusBar = true;
    };

    menuExtraClock.ShowSeconds = true;
    screencapture.type = "png";
  };

  time.timeZone = "America/New_York";

  # TODO: Add OpenSSH things
  users.users.tale = {
    name = "tale";
    home = "/Users/tale";
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
      ./nvim
      ./tui
    ];
  };
}
