{ lib, pkgs, config, ... }:
let dotdir = "${config.home.homeDirectory}/.config/dotfiles";
in
{
  launchd.agents.backup = {
    enable = true;
    config = {
      Label = "me.tale.backup";
      Program = "${dotdir}/launchd/me.tale.backup.sh";
      EnvironmentVariables = {
        PATH = "${pkgs.coreutils}/bin:${pkgs.restic}/bin";
        DOTDIR = dotdir;
      };
      StandardOutPath = "/tmp/launchd/backup.log";
      StandardErrorPath = "/tmp/launchd/backup.log";
      StartCalendarInterval = [{
        Minute = 0;
      }];
    };
  };

  launchd.agents.cleanup = {
    enable = true;
    config = {
      Label = "me.tale.cleanup";
      Program = "${dotdir}/launchd/me.tale.cleanup.sh";
      EnvironmentVariables = {
        PATH = "${pkgs.coreutils}/bin:/opt/homebrew/bin";
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
