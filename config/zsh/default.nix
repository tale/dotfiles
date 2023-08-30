{ pkgs, ... }: {
  home.packages = with pkgs; [ zsh ];

  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    envExtra = builtins.readFile ./.zshenv;
    initExtra = builtins.readFile ./.zshrc;
    profileExtra = builtins.readFile ./.zprofile;
    loginExtra = builtins.readFile ./.zlogin;
  };
}
