{ pkgs, ... }: {
  programs.git = {
    enable = true;
    userEmail = "aarnavtale@icloud.com";
    userName = "Aarnav Tale";
    signing = {
      gpgPath = "${pkgs.gnupg}/bin/gpg";
      key = "AA804838ACF0909C1713F4283205E18CEDD2C007";
      signByDefault = true;
    };
    aliases = {
      redo = "commit --amend -S";
    };
    hooks = {
      commit-msg = ./hook-commit-msg.sh;
      pre-commit = ./hook-pre-commit.sh;
    };
    ignores = [
      ".DS_Store"
      ".AppleDouble"
      ".LSOverride"
      "Icon\r"
      "._*"
      ".DocumentRevisions-V100"
      ".fseventsd"
      ".Spotlight-V100"
      ".TemporaryItems"
      ".Trashes"
      ".VolumeIcon.icns"
      ".com.apple.timemachine.donotpresent"
      ".AppleDB"
      ".AppleDesktop"
      "Network Trash Folder"
      "Temporary Items"
      ".apdisk"
      "*~"
    ];
    lfs.enable = true;
    delta.enable = true;
    extraConfig = {
      core = {
        editor = "${pkgs.neovim}/bin/nvim";
      };
      pull = {
        rebase = true;
      };
      init = {
        defaultBranch = "main";
      };
      protocol = {
        version = 2;
      };
      submodule = {
        fetchJobs = 4;
      };
      merge = {
        conflictstyle = "diff3";
      };
      push = {
        autoSetupRemote = true;
      };
    };
  };

  home.file.".huskyrc".text = ''
    HOOKS_DIR=$(git config --global core.hooksPath)
    HOOK_PATH="$HOOKS_DIR/$hook_name"

    # hook_name is from the husky script
    if [ -f "$HOOK_PATH" ]; then
      source "$HOOK_PATH"
    fi
  '';
}
