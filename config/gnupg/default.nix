{ lib, pkgs, ... }:

let pinentry-mac = "${pkgs.pinentry_mac}/Applications/pinentry-mac.app/Contents/MacOS/pinentry-mac";
in
{
  home.packages = with pkgs; [ gnupg ];

  programs.gpg = {
    enable = true;
    settings = {
      keyserver = "hkps://keys.openpgp.org";
    };
  };

  # services.gpg-agent only works on Linux
  # https://github.com/NixOS/nixpkgs/issues/240819
  home.file.".gnupg/gpg-agent.conf".text = lib.concatStrings [
    (builtins.readFile ./gpg-agent.conf)
    "\n"
    "pinentry-program ${pinentry-mac}"
  ];

  home.file.".gnugpg/scdaemon.conf".text = ''
    disable-ccid
  '';


  launchd.agents.gpg-agent = {
    enable = true;
    config = {
      ProgramArguments = [
        "${pkgs.gnupg}/bin/gpgconf"
        "--launch"
        "gpg-agent"
      ];
      RunAtLoad = true;
    };
  };
}
