{ pkgs, ... }: {
  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;

  homebrew = {
    enable = true;
    # TODO: MAS & Things3 + Other App Store
    caskArgs = {
      no_quarantine = true;
    };
    casks = [
      "1password"
      "alacritty"
      "aldente"
      "bartender"
      "cleanmymac"
      "cleanshot"
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
      "microsoft-powerpoint"
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
  home-manager.users.tale = { pkgs, lib, ... }: {
    home.stateVersion = "23.05";
    home.activation = {
      # nix-darwin doesn't set defaults when running as sudo
      smartCardDisablePairing = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        $DRY_RUN_CMD /usr/bin/sudo /usr/bin/defaults write /Library/Preferences/com.apple.security.smartcard UserPairing -bool false
      '';
    };

    programs.home-manager.enable = true;
    imports = [
      ./packages.nix
      ./env
      ./gitconfig
      ./zsh
      ./gnupg
      ./launchd
      ./nvim
      ./tui
    ];
  };
}
