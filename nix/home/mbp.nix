{ pkgs, ... }:
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
    ./lua-fennel.nix
    ./neovim.nix
    ./devtools.nix
  ];

  skr.home = {
    lua.enable = true;
    neovim.enable = true;
    devtools.enable = true;
  };

  programs.home-manager.enable = true;

  home = {
    inherit username homeDirectory;
    stateVersion = "24.11";

    packages = with pkgs; [
      nixd
      nixfmt

      go
      gopls

      rust-analyzer

      kubectl

      ansible
      vault
    ];
  };
}
