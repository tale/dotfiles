{ config, ... }:
let hammerspoonDir = "${config.home.homeDirectory}/.config/dotfiles/config/hammerspoon";
in
{
  home.file = {
    ".hammerspoon/" = {
      source = config.lib.file.mkOutOfStoreSymlink hammerspoonDir;
      recursive = true;
    };
  };
}
