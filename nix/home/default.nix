{ pkgs, ... }:
let
  username = "skr";
in
{
  home = {
    inherit username;
    homeDirectory = "/Users/${username}";
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

      lua
      fennel
      fennel-ls
      fnlfmt

      nil
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

  xdg.enable = true;

  programs.home-manager.enable = true;
}
