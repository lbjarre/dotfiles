{ pkgs, username, ... }:
{
  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    stateVersion = "24.11";

    packages = with pkgs; [
      neovim
      fzf
      ripgrep
      jujutsu
      atuin
      bat
      zoxide
      eza
      starship
      coreutils
      file
      difftastic
      delta
      direnv
      bottom
      tmux
      git-branchless
      util-linux

      nil
      nixfmt-rfc-style

      docker
      docker-compose
      krew

      go
      gopls
      gofumpt

      rustup
      fennel
      fnlfmt
      gcc

      awscli2

      glab
      lxd-lts
    ];

  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  nixpkgs.config.allowUnfreePredicate = _: true;
}
