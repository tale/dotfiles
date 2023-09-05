{ pkgs, config, ... }:
let nvimDir = "${config.home.homeDirectory}/.config/dotfiles/config/nvim";
in
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  home.file.".config/nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink nvimDir;
    recursive = true;
  };
}
