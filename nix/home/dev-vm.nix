{
  pkgs,
  agenix,
  username,
  config,
  ...
}:
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

      fennel
      fnlfmt
      fennel-ls
      gcc
      rust-analyzer
      deno

      awscli2

      glab
      lxd-lts

      agenix.packages.x86_64-linux.default
    ];
  };

  xdg.enable = true;

  age = {
    identityPaths = [ "${config.home.homeDirectory}/.ssh/id_ed25519" ];

    secrets.anthropic-key = {
      file = ../secrets/anthropic-key.age;
      path = "$HOME/.secrets/anthropic-key";
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  services.ssh-agent.enable = true;

  nixpkgs.config.allowUnfreePredicate = _: true;
}
