{ pkgs, ... }:
{
  programs.home-manager.enable = true;

  home.stateVersion = "24.11";
  home.username = "skr";
  home.homeDirectory = "/Users/skr";

  xdg.enable = true;

  # programs = {
  #   neovim.enable = true;
  # };

  home.packages = with pkgs; [
    # Basic shell programs
    atuin
    ripgrep
    direnv
    jujutsu
    starship
    bat
    eza
    fzf
    zoxide
    jq
    tmux
    bottom

    lua
    luajitPackages.fennel
    fnlfmt

    nil
    nixfmt-rfc-style

    rustup

    go

    kubectl

    ansible
    vault
  ];
}
