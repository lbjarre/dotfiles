{
  pkgs,
  username,
  config,
  ...
}:
let
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
      mergiraf
      direnv
      bottom
      tmux
      git-branchless
      util-linux
      entr

      agenix

      nixd
      nixfmt-rfc-style

      docker
      docker-compose
      kubectl

      go
      gopls
      gofumpt

      lua-language-server
      stylua
      fennel
      fnlfmt
      fennel-ls

      rust-analyzer
      bash-language-server
      deno
      terraform-ls

      # Dev stuff
      glab
      jira-cli-go
      awscli2
      s3cmd
      s5cmd
    ];
  };

  xdg = {
    enable = true;
    configFile = {
      "nvim".source = mkSymlink "${dotfiles}/nvim";
      "git".source = mkSymlink "${dotfiles}/config/git";
      "jj".source = mkSymlink "${dotfiles}/config/jj";
      "starship.toml".source = mkSymlink "${dotfiles}/config/starship.toml";
      "atuin".source = mkSymlink "${dotfiles}/config/atuin";
    };
  };
  home.file = {
    ".zshrc".source = mkSymlink "${dotfiles}/.zshrc";
    ".tmux.conf".source = mkSymlink "${dotfiles}/.tmux.conf";
  };

  age = {
    identityPaths = [ "${homeDirectory}/.ssh/id_ed25519" ];

    secrets = {
      anthropic-key = {
        file = ../secrets/anthropic-key.age;
        path = "${homeDirectory}/.secrets/ANTHROPIC_API_KEY";
      };
      evroc-atlassian-key = {
        file = ../secrets/evroc-atlassian-key.age;
        path = "${homeDirectory}/.secrets/JIRA_API_TOKEN";
      };
      github-key = {
        file = ../secrets/github-key.age;
        path = "${homeDirectory}/.secrets/GITHUB_API_TOKEN";
      };
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  services.ssh-agent.enable = true;

  nixpkgs.config.allowUnfreePredicate = _: true;
}
