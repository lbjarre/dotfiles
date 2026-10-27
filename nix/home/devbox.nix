{
  pkgs,
  username,
  ...
}:
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

      codex
      claude-code
      tilt
      krew
    ];
  };

  nixpkgs.config.allowUnfreePredicate = _: true;
}
