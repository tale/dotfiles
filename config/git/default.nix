{ pkgs, ... }: {
  home.packages = with pkgs; [ git ];

  programs.git = {
    enable = true;
    includes = [{ path = "~/.config/dotfiles/config/git/.gitconfig"; }];
  };
}
