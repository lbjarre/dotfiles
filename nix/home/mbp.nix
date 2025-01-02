{ pkgs, ... }:
{
  programs.home-manager.enable = true;

  home = {
    username = "skr";
    homeDirectory = "/Users/skr";
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

      nil
      nixfmt-rfc-style

      go
      gopls

      rust-analyzer

      kubectl

      ansible
      vault
    ];
  };

  xdg.enable = true;
}
