{
  pkgs,
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

      agenix

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

      cargo
      rust-analyzer

      bash-language-server

      deno

      gcc

      # Dev stuff
      glab
      jira-cli-go
      lxd-lts
      awscli2
      s3cmd
    ];
  };

  xdg.enable = true;

  age = {
    identityPaths = [ "${config.home.homeDirectory}/.ssh/id_ed25519" ];

    secrets = {
      anthropic-key = {
        file = ../secrets/anthropic-key.age;
        path = "$HOME/.secrets/ANTHROPIC_API_KEY";
      };
      evroc-atlassian-key = {
        file = ../secrets/evroc-atlassian-key.age;
        path = "$HOME/.secrets/JIRA_API_TOKEN";
      };
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  services.ssh-agent.enable = true;

  nixpkgs.config.allowUnfreePredicate = _: true;
}
