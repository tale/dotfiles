{ lib, pkgs, ... }:

let pinentry-mac = "${pkgs.pinentry_mac}/Applications/pinentry-mac.app/Contents/MacOS/pinentry-mac";
in
{
  home.packages = with pkgs; if pkgs.stdenv.isDarwin then [ pinentry_mac ] else [ ];

  programs.gpg = {
    enable = true;
    settings = {
      keyserver = "hkps://keys.openpgp.org";
    };
  };

  # services.gpg-agent only works on Linux
  # https://github.com/NixOS/nixpkgs/issues/240819
  # So the gpg-agent is managed by nix-darwin
  home.file =
    if pkgs.stdenv.isDarwin then {
      ".gnupg/gpg-agent.conf".text = lib.concatStrings [
        (builtins.readFile ./gpg-agent.conf)
        "\n"
        "pinentry-program ${pinentry-mac}"
      ];

      ".gnugpg/scdaemon.conf".text = ''
        disable-ccid
      '';
    } else { };

}
