{ agenix, pkgs, ... }:
let
  username = "skr";
  homeDirectory =
    let
      rootDir = if pkgs.stdenv.isLinux then "home" else "Users";
    in
    "/${rootDir}/${username}";
in
{
  imports = [
    agenix.homeManagerModules.default
    ./lua-fennel.nix
    ./neovim.nix
    ./devtools.nix
    ./opencode.nix
  ];

  skr.home = {
    lua.enable = true;
    neovim.enable = true;
    devtools.enable = true;
    opencode.enable = true;
  };

  home = {
    inherit username homeDirectory;
    stateVersion = "24.11";

    packages = with pkgs; [
      agenix

      nixd
      nixfmt

      cargo
      rust-analyzer

      go
      gopls
      gofumpt

      kubectl

      ansible
      vault
    ];
  };

  age = {
    identityPaths = [ "${homeDirectory}/.ssh/id_ed25519" ];
  };

  programs.home-manager.enable = true;
}
