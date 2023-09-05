{ pkgs, lib, ... }:
let
  alacritty_font = "Mononoki Nerd Font Mono";
in
{
  imports = [ ./tmux.nix ];
  programs.alacritty = {
    enable = if pkgs.stdenv.isDarwin then true else false;
    package = pkgs.zsh; # This is just a dummy placeholder since brew cask installs Alacritty
    settings = {
      shell = {
        program = "${pkgs.zsh}/bin/zsh";
        args = [ "-l" ];
      };

      env = {
        TERM = "xterm-256color";
      };

      window = {
        startup_mode = "Maximized";
        decorations_theme_variant = "Dark";
        decorations = "buttonless";
        option_as_alt = "OnlyLeft";
        padding = {
          x = 16;
          y = 16;
        };
      };

      font = {
        size = 15.0;
        normal = {
          family = alacritty_font;
          style = "Regular";
        };
        bold = {
          family = alacritty_font;
          style = "Bold";
        };
        italic = {
          family = alacritty_font;
          style = "Italic";
        };
        bold_italic = {
          family = alacritty_font;
          style = "Bold Italic";
        };
      };

      bell = {
        duration = 0;
      };

      colors = {
        primary = {

          background = "#0d1117";
          foreground = "#b3b1ad";
        };

        normal = {
          black = "#484f58";
          red = "#ff7b72";
          green = "#3fb950";
          yellow = "#d29922";
          blue = "#58a6ff";
          magenta = "#bc8cff";
          cyan = "#39c5cf";
          white = "#b1bac4";
        };

        bright = {
          black = "#6e7681";
          red = "#ffa198";
          green = "#56d364";
          yellow = "#e3b341";
          blue = "#79c0ff";
          magenta = "#d2a8ff";
          cyan = "#56d4dd";
          white = "#f0f6fc";
        };

        indexed_colors = [
          {
            index = 16;
            color = "#d18616";
          }
          {
            index = 17;
            color = "#ffa198";
          }
        ];
      };

      cursor = {
        style = {
          shape = "Block";
          blinking = "On";
        };
        blink_interval = 500;
        unfocused_hollow = true;
      };

      key_bindings = [
        {
          key = "V";
          mods = "Command";
          action = "Paste";
        }
        {
          key = "C";
          mods = "Command";
          action = "Copy";
        }
        {
          key = "F";
          mods = "Command";
          action = "SearchForward";
        }
        {
          key = "F";
          mods = "Command|Shift";
          action = "SearchBackward";
        }
      ];
    };
  };
}
