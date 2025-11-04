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
  imports = [
    ./lua-fennel.nix
    ./neovim.nix
  ];

  skr.home = {
    lua.enable = true;
    neovim.enable = true;
  };

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
      ripgrep
      starship
      tmux
      zoxide

      agenix

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
      "wezterm".source = mkSymlink "${dotfiles}/config/wezterm";
    };
  };

  programs.home-manager.enable = true;
}
