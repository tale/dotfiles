{
  description = "Home Manager Configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-23.05-darwin";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, darwin, nixpkgs-unstable, ... }:
    let
      pkgs = nixpkgs.legacyPackages."aarch64-darwin";
      pkgs-unstable = nixpkgs-unstable.legacyPackages."aarch64-darwin";
    in
    {
      darwinConfigurations."Aarnavs-MBP" = darwin.lib.darwinSystem {
        inherit pkgs;
        system = "aarch64-darwin"; # M1 Max
        modules = [
          home-manager.darwinModules.home-manager
          {
            home-manager.extraSpecialArgs = {
              inherit pkgs-unstable;
            };
          }
          ./config/system.nix
        ];
      };
    };
}
