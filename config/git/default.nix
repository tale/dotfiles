{ pkgs, ... }: {
  programs.git = {
    enable = true;
    includes = [{ path = "~/.config/dotfiles/config/git/.gitconfig"; }];
  };
}
