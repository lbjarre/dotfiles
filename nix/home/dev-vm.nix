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
  ];

  skr.home = {
    lua.enable = true;
    neovim.enable = true;
    devtools.enable = true;
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
      nixfmt-rfc-style

      docker
      docker-compose
      kubectl

      go
      gopls
      gofumpt

      rust-analyzer
      bash-language-server
      deno
      terraform-ls

      glab
      jira-cli-go
      awscli2
      s3cmd
      s5cmd
    ];
  };

  home.file = {
    ".zshrc".source = mkSymlink "${dotfiles}/.zshrc";

    # TODO: local executables. There is an XDG standard for this,
    # $HOME/.local/bin, but home-manager doesn't support it. I've had these in
    # $HOME/bin for now, but would be nice to have them in a standard place.
    "bin".source = mkSymlink "${dotfiles}/bin";
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
