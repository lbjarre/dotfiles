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

  xdg = {
    enable = true;
    configFile = {
      "starship.toml".source = mkSymlink "${dotfiles}/config/starship.toml";
      "jj".source = mkSymlink "${dotfiles}/config/jj";
      "nvim".source = mkSymlink "${dotfiles}/nvim";
    };
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
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  services.ssh-agent.enable = true;

  nixpkgs.config.allowUnfreePredicate = _: true;
}
