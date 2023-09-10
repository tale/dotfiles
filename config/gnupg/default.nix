{ lib, pkgs, config, ... }:
let
  pinentry-mac = "${pkgs.pinentry_mac}/Applications/pinentry-mac.app/Contents/MacOS/pinentry-mac";
  publicKeyFingerprint = "AA804838ACF0909C1713F4283205E18CEDD2C007";
in
{
  home.packages = with pkgs; [ pinentry_mac ];
  programs.gpg = {
    enable = true;
    settings = {
      keyserver = "hkps://keys.openpgp.org";
    };
  };

  # services.gpg-agent only works on Linux
  # So the gpg-agent is managed by nix-darwin
  home.file = {
    ".gnupg/gpg-agent.conf".text = lib.concatStrings [
      (builtins.readFile ./gpg-agent.conf)
      "\n"
      "pinentry-program ${pinentry-mac}"
    ];

    ".gnugpg/scdaemon.conf".text = ''
      disable-ccid
    '';
  };

  home.activation = {
    downloadPublicKey = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      $DRY_RUN_CMD ${pkgs.gnupg}/bin/gpg \
        --keyserver ${config.programs.gpg.settings.keyserver} \
        --recv-keys ${publicKeyFingerprint}
    '';
  };
}
