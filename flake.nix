{
  description = "Home Manager Configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-23.05-darwin";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      arch = "aarch64-darwin";
    in
    {
      defaultPackage.${arch} = home-manager.defaultPackage.${arch};

      homeConfigurations.tale = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${arch};
        modules = [
          {
            home.username = "tale";
            home.homeDirectory = "/Users/tale";
            home.stateVersion = "23.05";
            programs.home-manager.enable = true;

            imports = [
              ./config/packages.nix
              ./config/zsh
              ./config/git
            ];
          }
        ];
      };
    };
}
