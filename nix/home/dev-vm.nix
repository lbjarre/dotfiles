{
  pkgs,
  config,
  username,
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
  imports = [
    ./lua-fennel.nix
    ./neovim.nix
    ./devtools.nix
    ./opencode.nix
    ./tmux
    ./pi
  ];

  skr.home = {
    lua.enable = true;
    neovim.enable = true;
    devtools.enable = true;
    opencode.enable = false;
    tmux.enable = true;
    pi.enable = true;
  };

  home = {
    inherit username homeDirectory;
    stateVersion = "24.11";

    packages = with pkgs; [
      file
      git-branchless
      util-linux

      agenix

      nixd
      nixfmt

      docker
      docker-compose
      kubectl

      go
      gopls
      gofumpt

      rust-analyzer
      rustfmt

      bash-language-server
      deno
      terraform-ls

      awscli2
      watchman
      gh

      claude-code
    ];
  };

  home.file = {
    ".zshrc".source = mkSymlink "${dotfiles}/.zshrc";
  };

  age = {
    identityPaths = [ "${homeDirectory}/.ssh/id_ed25519" ];

    secrets = {
      # anthropic-key = {
      #   file = ../secrets/anthropic-key.age;
      #   path = "${homeDirectory}/.secrets/ANTHROPIC_API_KEY";
      # };
      # evroc-atlassian-key = {
      #   file = ../secrets/evroc-atlassian-key.age;
      #   path = "${homeDirectory}/.secrets/JIRA_API_TOKEN";
      # };
      # github-key = {
      #   file = ../secrets/github-key.age;
      #   path = "${homeDirectory}/.secrets/GITHUB_API_TOKEN";
      # };
      # evroc-gitlab-token = {
      #   file = ../secrets/evroc-gitlab-token.age;
      #   path = "${homeDirectory}/.secrets/GITLAB_API_TOKEN";
      # };
    };
  };

  nix = {
    enable = true;
    package = pkgs.nix;
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    settings.trusted-users = [
      username # I trust myself, big mistake.
      "root"
    ];
    # Extra options as suggested by devenv.
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
    '';
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  services.ssh-agent.enable = true;

  nixpkgs.config.allowUnfreePredicate = _: true;
}
