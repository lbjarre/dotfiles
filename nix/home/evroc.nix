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
  home = {
    inherit username homeDirectory;
    stateVersion = "24.11";

    packages = with pkgs; [
      # Basic shell programs
      atuin
      bat
      bottom
      coreutils
      delta
      difftastic
      direnv
      eza
      fzf
      jq
      jujutsu
      neovim
      ripgrep
      starship
      tmux
      zoxide

      agenix

      lua
      lua-language-server
      stylua
      fennel
      fennel-ls
      fnlfmt

      nixd
      nixfmt-rfc-style

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

  xdg = {
    enable = true;
    configFile = {
      "starship.toml".source = mkSymlink "${dotfiles}/config/starship.toml";
      "jj".source = mkSymlink "${dotfiles}/config/jj";
      "nvim".source = mkSymlink "${dotfiles}/nvim";
      "wezterm".source = mkSymlink "${dotfiles}/config/wezterm";
    };
    dataFile = {
      "fennel-ls/docsets/nvim.lua".source = pkgs.callPackage ./nvim-docset.nix { };
    };
  };

  programs.home-manager.enable = true;
}
