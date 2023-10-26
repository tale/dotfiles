{ pkgs, lib, config, ... }: {
  home.file.".config/wezterm/wezterm.lua".text = builtins.readFile ./wezterm.lua;
  programs.tmux = {
    enable = true;
    shell = "${pkgs.zsh}/bin/zsh";
    extraConfig = builtins.readFile ./tmux.conf;
  };
}

