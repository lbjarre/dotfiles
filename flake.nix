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
    agenix.inputs.home-manager.follows = "home-manager";
  };

  outputs =
    {
      nixpkgs,
      nix-darwin,
      home-manager,
      agenix,
      ...
    }:
    let
      vmUsername = "lbjarre";
      addOverlays.nixpkgs.overlays = [ agenix.overlays.default ];
      forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;
    in
    {
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt);

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
      darwinConfigurations."MBP-YTV-LBJ" = nix-darwin.lib.darwinSystem {
        modules = [
          ./nix/darwin/evroc.nix
          agenix.darwinModules.default
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.users.skr = ./nix/home/evroc.nix;
          }
          addOverlays
        ];
      };

      # Standalone home-manager config for work dev VM.
      homeConfigurations.${vmUsername} = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs { system = "x86_64-linux"; };
        extraSpecialArgs = {
          username = vmUsername;
        };
        modules = [
          ./nix/home/dev-vm.nix
          addOverlays
          agenix.homeManagerModules.default
        ];
      };
    };
}
