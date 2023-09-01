{ lib, pkgs, config, ... }:
let launchDir = "${config.home.homeDirectory}/.config/dotfiles/config/launchd";
in
{
  launchd.agents.backup = {
    enable = true;
    config = {
      Label = "me.tale.backup";
      Program = "${launchDir}/backup.sh";
      EnvironmentVariables = {
        PATH = "${pkgs.coreutils}/bin:${pkgs.restic}/bin:${pkgs.zsh}/bin:/usr/bin";
        RESTIC_EXCLUDE = "${launchDir}/backup_excludes.txt";
      };
      StandardOutPath = "/tmp/launchd/backup.log";
      StandardErrorPath = "/tmp/launchd/backup.log";
      StartInterval = 3600; # 1 hour
    };
  };

  launchd.agents.cleanup = {
    enable = true;
    config = {
      Label = "me.tale.cleanup";
      Program = "${launchDir}/cleanup.sh";
      EnvironmentVariables = {
        PATH = "${pkgs.coreutils}/bin:${pkgs.zsh}/bin:/opt/homebrew/bin";
      };
      StandardOutPath = "/tmp/launchd/cleanup.log";
      StandardErrorPath = "/tmp/launchd/cleanup.log";
      StartCalendarInterval = [{
        Hour = 20;
        Minute = 0;
      }];
    };
  };
}
