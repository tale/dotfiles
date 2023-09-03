{ pkgs, lib, ... }: {
  home.activation = {
    zshRecompile = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      HM_REBUILD=1 $DRY_RUN_CMD ${pkgs.zsh}/bin/zsh -l -c 'exit'
    '';
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

      cat = if pkgs.stdenv.isDarwin then "bat" else "batcat";
      ls = "ls --color=auto -lah";
      ll = "ls --color=auto -lah";
      la = "ls --color=auto -lah";

      nano = "nvim";
      vim = "nvim";
      htop = "btop";

      mk = "minikube";
      mkmk = "minikube start --driver=docker --kubernetes-version=v1.27.0";
      nix-rebuild = "darwin-rebuild switch --flake .";
      nix-gc = "nix-collect-garbage --delete-old";
      motd = if pkgs.stdenv.isLinux then "cat /run/motd.dynamic" else "";
    };

    sessionVariables = {
      DOTDIR = "$HOME/.config/dotfiles";
      EDITOR = "nvim";
      LESSHISTFILE = "-";
      OS = "$(uname -s)";
      dd = "$DOTDIR";

      PNPM_HOME = if pkgs.stdenv.isDarwin then "$HOME/Library/pnpm" else null;
      BUN_INSTALL = if pkgs.stdenv.isDarwin then "$HOME/.bun" else null;
      THEOS = if pkgs.stdenv.isDarwin then "$HOME/Library/Theos" else null;
      d = if pkgs.stdenv.isDarwin then "$HOME/Developer" else null;
      GPG_TTY = if pkgs.stdenv.isLinux then "$(tty)" else null;
    };
  };
}
