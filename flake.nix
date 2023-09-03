{
  description = "Home Manager Configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-23.05-darwin";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, darwin }: {
    darwinConfigurations."Aarnavs-MBP" = darwin.lib.darwinSystem {
      system = "aarch64-darwin"; # M1 Max
      modules = [
        home-manager.darwinModules.home-manager
        ./config/macbook.nix
      ];
    };
  };
}
