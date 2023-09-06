{ lib, pkgs, config, ... }:
let
  dotDir = "${config.home.homeDirectory}/.config/dotfiles";
  launchhDir = "${dotDir}/config/launchd";
  snippetFile = "${dotDir}/config/tui/colors.yaml";
  stateFile = "${config.home.homeDirectory}/.local/state/alacritty.yaml";

  dark_listener = pkgs.stdenv.mkDerivation rec {
    pname = "dark_listener";
    version = "0.1.0";

    src = [
      ./dark_listener.swift
    ];

    dontPatch = true;
    dontFixup = true;
    dontConfigure = true;

    unpackPhase = ''
      for srcFile in $src; do
            # Copy file into build dir
            local tgt=$(echo $srcFile | cut --delimiter=- --fields=2-)
            cp $srcFile $tgt
          done
    '';

    buildPhase = ''
      # Check for Xcode and fail if it's not installed
      if ! /usr/bin/xcodebuild -version &> /dev/null; then
        echo "Please install Xcode from the App Store."
        exit 1
      fi

      export SDKROOT=$(/usr/bin/xcrun --sdk macosx --show-sdk-path)
      export SWIFTC=$(/usr/bin/xcrun -f swiftc)
      $SWIFTC -o dark_listener dark_listener.swift
    '';

    installPhase = ''
      mkdir -p $out/bin
      install -m 0755 dark_listener $out/bin
    '';

    meta = {
      description = "A daemon to listen for dark mode changes";
      platforms = lib.platforms.darwin;
      license = lib.licenses.mit;
    };
  };
in
{
  home.packages = [ dark_listener ];
  launchd.agents.color = {
    enable = true;
    config = {
      Label = "me.tale.color";
      ProgramArguments = [
        "${dark_listener}/bin/dark_listener"
        snippetFile
        stateFile
      ];
      StandardOutPath = "/tmp/launchd/background.log";
      StandardErrorPath = "/tmp/launchd/background.log";
      KeepAlive = true;
    };
  };
}
