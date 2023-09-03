{ pkgs, lib, ... }: {
  home.activation = {
    zshRecompile = lib.hm.dag.entryAfter [ "writeBoundary" ] "HM_REBUILD=1 ${pkgs.zsh}/bin/zsh -l -c 'exit'";
  };

  programs.zsh = {
    enable = true;

    # Compile scripts for faster loading times
    loginExtra = builtins.readFile ./.zlogin;
    initExtra = builtins.readFile ./.zshrc;

    dotDir = ".config/zsh";
    autocd = true;
    defaultKeymap = "viins";
    enableAutosuggestions = true;
    enableCompletion = false; # Manually enabled later
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
      nix-reload = "darwin-rebuild switch --flake .";
      nix-gc = "nix-collect-garbage --delete-old";
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
    };
  };
}
