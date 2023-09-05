{ pkgs, lib, ... }: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    extraLuaConfig = builtins.readFile ./init.lua;
  };

  home.file = {
    NvimLazyLock = {
      source = ./lazy-lock.json;
      target = ".config/nvim/lazy-lock.json";
    };

    NvimLuaFolder = {
      source = ./lua;
      target = ".config/nvim/lua";
      recursive = true;
    };
  };
}
