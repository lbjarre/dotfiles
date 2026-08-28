{
  pkgs,
  config,
  username,
  ...
}:
let
  inherit (config.home) homeDirectory;
in
{
  imports = [
    ./skr.nix
  ];

  skr.home = {
    enable = true;
    inherit username;
  };

  home = {
    stateVersion = "24.11";
    packages = with pkgs; [
      file
      git-branchless
      util-linux
      glibcLocales

      agenix

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
  };

  age = {
    secrets = {
      github-token = {
        file = ../secrets/modal-github-key.age;
        path = "${homeDirectory}/.secrets/GITHUB_TOKEN";
      };
    };
  };

  nixpkgs.config.allowUnfreePredicate = _: true;
}
