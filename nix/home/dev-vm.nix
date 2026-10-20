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
      glibcLocales

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
      tilt
      krew
    ];

    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
  };

  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";

    autosuggestion.enable = true;

    initContent = ''
      source ${dotfiles}/.zshrc
    '';
  };

  age = {
    identityPaths = [ "${homeDirectory}/.ssh/id_ed25519" ];

    secrets = {
      github-token = {
        file = ../secrets/modal-github-key.age;
        path = "${homeDirectory}/.secrets/GITHUB_TOKEN";
      };
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
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  services.ssh-agent.enable = true;

  nixpkgs.config.allowUnfreePredicate = _: true;
}
