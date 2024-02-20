{ pkgs, ... }: {
  nix.package = pkgs.nixFlakes;
  services.nix-daemon.enable = true;
  time.timeZone = "America/New_York";

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
    SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;
    menuExtraClock.ShowSeconds = true;
    screencapture.type = "png";

    CustomUserPreferences = {
      NSGlobalDomain = {
        NSWindowShouldDragOnGesture = true;
        NSAutomaticWindowAnimationsEnabled = false;
        AppleFontSmoothing = 1;
      };
      "org.alacritty" = {
        AppleFontSmoothing = 0;
      };
    };
    dock = {
      autohide = true;
      autohide-delay = 1000.0;
      wvous-tl-corner = 12; # Notification Center
      wvous-tr-corner = 12;
      wvous-bl-corner = 11; # Launchpad
      wvous-br-corner = 11;
    };
    finder = {
      ShowPathbar = true;
      ShowStatusBar = true;
    };
  };
}
