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

  programs.home-manager.enable = true;

  home = {
    inherit username homeDirectory;
    stateVersion = "24.11";

    packages = with pkgs; [
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
    };
  };
}
