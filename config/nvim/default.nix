{ pkgs, config, ... }: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  home.file.".config/nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/Developer/personal/dotfiles/config/nvim";
    recursive = true;
  };
}
