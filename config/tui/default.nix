{ pkgs, lib, config, ... }:
let
  alacritty_font = "Mononoki Nerd Font Mono";
  alacritty_state = "${config.home.homeDirectory}/.local/state/alacritty.yaml";
in
{
  imports = [ ./tmux.nix ];

  home.file.".config/alacritty/alacritty.yml".text = builtins.replaceStrings
    [ "{alacritty_state}" "{alacritty_font}" "{zsh_path}" ]
    [ alacritty_state alacritty_font "${pkgs.zsh}/bin/zsh" ]
    (builtins.readFile ./alacritty.yaml);
}


