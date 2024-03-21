{ config, ... }: {
  programs.ssh = {
    enable = true;
    compression = true;
    controlMaster = "auto";
    controlPath = "/tmp/ssh-%C";
    forwardAgent = true;
    includes = [
      "${config.home.homeDirectory}/.ssh/private.config"
      "${config.home.homeDirectory}/.orbstack/ssh/config"
    ];
  };
}
