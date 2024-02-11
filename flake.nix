{
  inputs = {
    pkgs.url = "github:nixos/nixpkgs/nixpkgs-23.11-darwin";
    u_pkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    hm.url = "github:nix-community/home-manager/release-23.11";
    os.url = "github:lnl7/nix-darwin";

    hm.inputs.nixpkgs.follows = "pkgs";
    os.inputs.nixpkgs.follows = "pkgs";
  };

  outputs = { self, pkgs, u_pkgs, hm, os }:
    let unstable = u_pkgs.legacyPackages."aarch64-darwin"; in
    {
      darwinConfigurations."Aarnavs-MBP" = os.lib.darwinSystem {
        system = "aarch64-darwin"; # M1 Max
        modules = [
          hm.darwinModules.home-manager
          { home-manager.extraSpecialArgs = { inherit unstable; }; }
          ./config/system.nix
          ./config/brew.nix
          ./config/home.nix
        ];
      };
    };
}
