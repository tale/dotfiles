{ pkgs, ... }: {
  home.packages = with pkgs; [ rustup ];
  home.file = {
    ".theosrc".text = ''
      THEOS_DEVICE_IP ?= localhost
      THEOS_DEVICE_PORT ?= 2222
    '';
    ".huskyrc".text = ''
      HOOKS_DIR=$(git config --global core.hooksPath)
      HOOK_PATH="$HOOKS_DIR/$hook_name"

      # hook_name is from the husky script
      if [ -f "$HOOK_PATH" ]; then
        source "$HOOK_PATH"
      fi
    '';
  };

  home.activation = {
    installTheos = ''
      THEOS="$HOME/Library/Theos"
      [ -d "$THEOS" ] || $DRY_RUN_CMD ${pkgs.git}/bin/git clone --recursive https://github.com/theos/theos.git "$THEOS"
    '';
  };
}
