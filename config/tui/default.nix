{ pkgs, lib, config, ... }:
let
  alacritty_font = "Mononoki Nerd Font Mono";
  alacritty_state = "${config.home.homeDirectory}/.local/state/alacritty.yaml";
in
{
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

  home.file.".config/alacritty/alacritty.yml".text = builtins.replaceStrings
    [ "{alacritty_state}" "{alacritty_font}" "{zsh_path}" ]
    [ alacritty_state alacritty_font "${pkgs.zsh}/bin/zsh" ]
    (builtins.readFile ./alacritty.yaml);
}


