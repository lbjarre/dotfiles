{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-26.05";

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
      nixpkgs-stable,
      nix-darwin,
      home-manager,
      agenix,
      ...
    }:
    let
      vmUsername = "ec2-user";
      overlays = [
        agenix.overlays.default
        (
          final: prev:
          let
            system = prev.stdenv.hostPlatform.system;
            stable = nixpkgs-stable.legacyPackages.${system};
          in
          {
            buildJanetApp = (prev.callPackage ./nix/lib/janet { }).packages.default;
            wttr = prev.callPackage ./cmd/wttr { };

            # Packages to build from stable because of various reasons.
            inherit (stable)
              # Keep devenv from stable, have some repos that does not build on v2
              # which is in unstable.
              devenv
              # git-branchless fails to build on unstable right now.
              git-branchless
              ;
          }
        )
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
            home-manager.extraSpecialArgs = { inherit agenix; };
          }
          addOverlays
        ];
      };

      # Darwin config for work laptop.
      darwinConfigurations."lukas-modal" = nix-darwin.lib.darwinSystem {
        specialArgs = { inherit agenix; };
        modules = [
          addOverlays
          ./nix/darwin/modal.nix
          agenix.darwinModules.default
          home-manager.darwinModules.home-manager
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
