{ pkgs, config, ... }:
let
  pinentry-mac = "${pkgs.pinentry_mac}/Applications/pinentry-mac.app/Contents/MacOS/pinentry-mac";
in
{
  home.packages = with pkgs; [ pinentry_mac ];
  programs.gpg = {
    enable = true;
    settings = {
      keyserver = "hkps://pgp.mit.edu";
      default-key = "3205E18CEDD2C007";
    };
  };

  home.file."gnupg/gpg-agent.conf".text =
    ''
      	enable-ssh-support
      	default-cache-ttl 600
      	default-cache-ttl-ssh 600
      	max-cache-ttl 7200
      	max-cache-ttl-ssh 7200
      	use-standard-socket
      	pinentry-program ${pinentry-mac}
    '';
}
