{ pkgs, lib, config, ... }: {
  home.packages = with pkgs; [ tmate ];
  home.file.".config/wezterm/wezterm.lua".text = builtins.readFile ./wezterm.lua;

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

