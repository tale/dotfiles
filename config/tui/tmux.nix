{ pkgs, lib, ... }: {
  home.packages = with pkgs; [ tmate ];
  programs.tmux = {
    enable = true;
    prefix = "C-space";
    shell = "${pkgs.zsh}/bin/zsh";
    terminal = "screen-256color";

    aggressiveResize = true;
    baseIndex = 1;
    escapeTime = 0;
    historyLimit = 50000;
    keyMode = "vi";
    extraConfig = builtins.readFile ./tmux.conf;
  };
}

