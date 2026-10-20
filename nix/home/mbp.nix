{ pkgs, config, ... }:
let
  username = "skr";
  homeDirectory =
    let
      rootDir = if pkgs.stdenv.isLinux then "home" else "Users";
    in
    "/${rootDir}/${username}";

  dotfiles = "${homeDirectory}/src/github.com/lbjarre/dotfiles";
in
{
  imports = [
    ./lua-fennel.nix
    ./neovim.nix
    ./devtools.nix
    ./tmux
  ];

  skr.home = {
    lua.enable = true;
    neovim.enable = true;
    devtools.enable = true;
    tmux.enable = true;
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

    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
  };

  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";

    autosuggestion.enable = true;

    initContent = ''
      source ${dotfiles}/.zshrc
    '';
  };
}
