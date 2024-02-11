{ pkgs, ... }: {
  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;

  users.users.tale = {
    name = "tale";
    home = "/Users/tale";
    shell = pkgs.bashInteractive;
  };

  home-manager.users.tale = { pkgs, lib, ... }: {
    home.stateVersion = "23.11";
    home.activation.taleScript = lib.hm.dag.entryAfter [ "writeBoundary" ]
      ''${builtins.readFile ./activation.sh}'';

    fonts.fontconfig.enable = true;
    programs.home-manager.enable = true;
    imports = [
      ./packages.nix
      ./tools/git.nix
      ./tools/gpg.nix
      ./tools/ssh.nix
      ./bash
      ./nvim
    ];
  };
}
