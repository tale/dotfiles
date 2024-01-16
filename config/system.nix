{ pkgs, ... }: {
  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;

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
      "adobe-acrobat-reader"
      "aerospace"
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
      "maccy"
      "microsoft-excel"
      "microsoft-powerpoint"
      "microsoft-word"
      "minecraft"
      "monitorcontrol"
      "mullvadvpn"
      "orbstack"
      "postman"
      "sensei"
      "soulver"
      "spotify"
      "steam"
      "syncthing"
      "tailscale"
      "the-unarchiver"
      "wezterm"
      "xcodes"
      "zoom"
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

  environment.shells = [ pkgs.bashInteractive ];
  programs.bash = {
    enable = true;
    enableCompletion = true;
  };

  system.defaults = {
    NSGlobalDomain = {
      NSAutomaticWindowAnimationsEnabled = false;
    };
    CustomUserPreferences = {
      NSGlobalDomain = {
        NSWindowShouldDragOnGesture = true;
      };
      "com.apple.dock" = {
        show-recent-count = 1;
      };
    };
    SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;
    dock = {
      autohide = true;
      autohide-delay = 0.0;
      autohide-time-modifier = 0.5;
      showhidden = true;
      show-recents = true;
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
    shell = pkgs.bashInteractive;
  };

  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
  home-manager.users.tale = { pkgs, lib, ... }: {
    home.stateVersion = "23.11";
    home.activation = {
      bashShell = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        		$DRY_RUN_CMD /usr/bin/sudo /usr/bin/chsh -s "/run/current-system/sw${pkgs.bashInteractive.shellPath}" tale
        	'';

      # nix-darwin doesn't set defaults when running as sudo
      smartCardDisablePairing = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        		$DRY_RUN_CMD /usr/bin/sudo /usr/bin/defaults write /Library/Preferences/com.apple.security.smartcard UserPairing -bool false
        	  '';
    };

    programs.home-manager.enable = true;
    imports = [
      ./packages.nix
      ./bash
      ./env
      ./gitconfig
      ./gnupg
      ./hammerspoon
      ./nvim
    ];
  };

  system.patches = [
    (pkgs.writeText "pam_tid.patch" ''
      --- /etc/pam.d/sudo	2023-09-28 09:27:50
      +++ /etc/pam.d/sudo	2023-09-28 09:27:54
      @@ -1,4 +1,6 @@
       # sudo: auth account password session
      +auth       optional       ${pkgs.pam-reattach}/lib/pam/pam_reattach.so
      +auth       sufficient     pam_tid.so
       auth       include        sudo_local
       auth       sufficient     pam_smartcard.so
       auth       required       pam_opendirectory.so
    '')
  ];
}
