{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      nix-darwin,
      home-manager,
      agenix,
    }:
    let
      linuxPkgs = import nixpkgs {
        system = "x86_64-linux";
        overlays = [ agenix.overlays.default ];
      };
      vmUsername = "lbjarre";
      addOverlays.nixpkgs.overlays = [ agenix.overlays.default ];
    in
    {
      formatter.aarch64-darwin = nixpkgs.legacyPackages.aarch64-darwin.nixfmt-rfc-style;

      # Darwin config for mbp.
      darwinConfigurations."mbp" = nix-darwin.lib.darwinSystem {
        modules = [
          ./nix/darwin/mbp.nix
          agenix.darwinModules.default
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.users.skr = ./nix/home/mbp.nix;
          }
        ];

      };

      # Darwin config for work laptop.
      darwinConfigurations."lbjarre-mbp" = nix-darwin.lib.darwinSystem {
        modules = [
          ./nix/darwin/evroc.nix
          agenix.darwinModules.default
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.users.skr = ./nix/home;
          }
          addOverlays
        ];
      };

      # Standalone home-manager config for work dev VM.
      homeConfigurations.${vmUsername} = home-manager.lib.homeManagerConfiguration {
        pkgs = linuxPkgs;
        extraSpecialArgs = {
          username = vmUsername;
        };
        modules = [
          ./nix/home/dev-vm.nix
          agenix.homeManagerModules.default
        ];
      };
    };
}
