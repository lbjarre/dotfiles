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
      overlays = [
        agenix.overlays.default
        (final: prev: {
          buildJanetApp = (prev.callPackage ./nix/lib/janet { }).packages.default;
          wttr = prev.callPackage ./cmd/wttr { };
        })
      ];
      addOverlays.nixpkgs.overlays = overlays;
      forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;
    in
    {
      inherit overlays;
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt);
      packages = forAllSystems (
        system:
        let
          pkgs = import nixpkgs { inherit system overlays; };
        in
        {
          inherit (pkgs) wttr;
        }
      );

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
          addOverlays
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
