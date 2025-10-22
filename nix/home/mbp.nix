{ pkgs, config, ... }:
let
  username = "skr";
  homeDirectory =
    let
      rootDir = if pkgs.stdenv.isLinux then "home" else "Users";
    in
    "/${rootDir}/${username}";
  dotfiles = "${homeDirectory}/src/github.com/lbjarre/dotfiles";
  mkSymlink = config.lib.file.mkOutOfStoreSymlink;
in
{
  programs.home-manager.enable = true;

  home = {
    inherit username homeDirectory;
    stateVersion = "24.11";

    packages = with pkgs; [
      # Basic shell programs
      neovim
      atuin
      ripgrep
      direnv
      jujutsu
      starship
      coreutils
      difftastic
      delta
      bat
      eza
      fzf
      zoxide
      jq
      tmux
      bottom

      lua
      fennel
      fennel-ls
      fnlfmt

      nixd
      nixfmt-rfc-style

      go
      gopls

      rust-analyzer

      kubectl

      ansible
      vault
    ];
  };

  xdg = {
    enable = true;
    configFile = {
      "starship.toml".source = mkSymlink "${dotfiles}/config/starship.toml";
      "wezterm".source = mkSymlink "${dotfiles}/config/wezterm";
      "nvim".source = mkSymlink "${dotfiles}/nvim";
    };
    dataFile = {
      "fennel-ls/docsets/nvim.lua".source = pkgs.callPackage ./nvim-docset.nix { };
    };
  };
}
