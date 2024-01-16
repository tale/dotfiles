{ pkgs, lib, ... }: {
  home.file.".config/wezterm/wezterm.lua".text = builtins.readFile ./wezterm.lua;
  home.file.".aerospace.toml".text = builtins.readFile ./aerospace.toml;

  programs.tmux = {
    enable = true;
    sensibleOnTop = false;
    shell = "/run/current-system/sw${pkgs.bashInteractive.shellPath}";
    extraConfig = builtins.readFile ./tmux.conf;
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    bashrcExtra = builtins.readFile ./login.bash;

    # Loads the git-prompt so that we can have the branch in the prompt
    initExtra = lib.concatStrings [
      ". ${pkgs.git}/share/git/contrib/completion/git-prompt.sh"
      "\n"
      (builtins.readFile ./interactive.bash)
    ];
  };
}
