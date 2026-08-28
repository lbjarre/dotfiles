{
  agenix,
  config,
  pkgs,
  ...
}:
let
  inherit (config.home) homeDirectory;
  inherit (config.skr.home) dotfilesDirectory;

  mkSymlink = p: config.lib.file.mkOutOfStoreSymlink "${dotfilesDirectory}/${p}";
in
{
  imports = [
    agenix.homeManagerModules.default
    ./skr.nix
  ];

  skr.home = {
    enable = true;
  };

  home = {
    stateVersion = "24.11";

    packages = with pkgs; [
      pkgs.agenix
      cargo
      rust-analyzer
      rustfmt
      rustc
      claude-code
    ];

    file = {
      # TODO: local executables. There is an XDG standard for this,
      # $HOME/.local/bin, but home-manager doesn't support it. I've had these in
      # $HOME/bin for now, but would be nice to have them in a standard place.
      "bin".source = mkSymlink "bin";
    };
  };

  age = {
    secrets = {
      modal-github-key = {
        file = ../secrets/modal-github-key.age;
        path = "${homeDirectory}/.secrets/MODAL_GITHUB_API_TOKEN";
      };
    };
  };
}
