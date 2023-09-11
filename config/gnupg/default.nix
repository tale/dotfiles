{ lib, pkgs, config, ... }:
let
  pinentry-mac = "${pkgs.pinentry_mac}/Applications/pinentry-mac.app/Contents/MacOS/pinentry-mac";
  publicKeyFingerprint = "3205E18CEDD2C007";
in
{
  home.packages = with pkgs; [ pinentry_mac ];
  programs.gpg = {
    enable = true;
    settings = {
      keyserver = "hkps://pgp.mit.edu";
      default-key = publicKeyFingerprint;
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
  };

  home.activation = {
    downloadPublicKey = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      # Check if the public key is already imported first
      if ! ${pkgs.gnupg}/bin/gpg --list-keys ${publicKeyFingerprint} > /dev/null 2>&1; then
        $DRY_RUN_CMD ${pkgs.gnupg}/bin/gpg \
          --keyserver ${config.programs.gpg.settings.keyserver} \
          --recv-keys ${publicKeyFingerprint}

        $DRY_RUN_CMD echo -e "5\ny\n" | ${pkgs.gnupg}/bin/gpg \
          --command-fd 0
          --expert
          --edit-key ${publicKeyFingerprint} trust
      fi
    '';
  };
}
