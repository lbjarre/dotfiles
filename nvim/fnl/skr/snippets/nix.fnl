(local {:snippet s :insert_node i} (require :luasnip))
(local {: fmt} (require :luasnip.extras.fmt))

;; Snippet for stubbing out a basic Nix flake. Mostly for the forAllSystems
;; function, making it cross-platform.
(local snippet-flake
       (do
         (local txt "{
   inputs.nixpkgs.url = \"github:NixOS/nixpkgs/nixpkgs-unstable\";
   outputs =
     { nixpkgs, ... }:
     let
       forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;
     in
     {
       devShells = forAllSystems (
         system:
         let
           pkgs = import nixpkgs { inherit system; };
         in
         {
           default = pkgs.mkShell {
             packages = [<>];
           };
         }
       );
     };
}")
         (s :flake (fmt txt [(i 1)] {:delimiters "<>"}))))

{:snippets [snippet-flake]}
