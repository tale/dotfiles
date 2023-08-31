{ pkgs, ... }: {
  home.packages = with pkgs; [ zsh ];

  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    autocd = true;
    defaultKeymap = "viins";
    enableAutosuggestions = true;
    initExtra = builtins.readFile ./.zshrc;
    profileExtra = builtins.readFile ./.zprofile;
    loginExtra = builtins.readFile ./.zlogin;
    history = {
      expireDuplicatesFirst = true;
      extended = true;
      ignoreDups = true;
      save = 10000;
      share = true;
      size = 10000;
    };

    shellAliases = {
      g = "git";
      t = "task";
      p = "pnpm";
      c = "cargo";
      d = "docker";
      k = "kubectl";

      cat = "bat";
      ls = "ls --color=auto -lah";
      ll = "ls --color=auto -lah";
      la = "ls --color=auto -lah";

      nano = "nvim";
      vim = "nvim";
      htop = "btop";

      mk = "minikube";
      mkmk = "minikube start --driver=docker --kubernetes-version=v1.27.0";
      nix-reload = "home-manager switch -b bak --flake $DOTDIR";
    };

    sessionVariables = {
      DOTDIR = "$HOME/.config/dotfiles";
      EDITOR = "nvim";
      LESSHISTFILE = "-";
      OS = "$(uname -s)";
      dd = "$DOTDIR";
      gpg = "$HOME/.gnupg";


      HOMEBREW_INSTALL_FROM_API = "1";
      HOMEBREW_NO_ENV_HINTS = "1";

      PNPM_HOME = "${if pkgs.stdenv.isDarwin then "$HOME/Library/pnpm" else null}";
      BUN_INSTALL = "${if pkgs.stdenv.isDarwin then "$HOME/.bun" else null}";
      d = "${if pkgs.stdenv.isDarwin then "$HOME/Developer" else null}";
      PATH = "${if pkgs.stdenv.isDarwin then "$PNPM_HOME:$BUN_INSTALL/bin:$PATH" else "$PATH"}";
    };
  };
}