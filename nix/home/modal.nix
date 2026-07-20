{
  agenix,
  config,
  pkgs,
  ...
}:
let
  username = "skr";
  homeDirectory =
    let
      rootDir = if pkgs.stdenv.isLinux then "home" else "Users";
    in
    "/${rootDir}/${username}";

  dotfiles = "${homeDirectory}/src/github.com/lbjarre/dotfiles";
  mkSymlink = p: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${p}";
in
{
  imports = [
    agenix.homeManagerModules.default
    ./lua-fennel.nix
    ./neovim.nix
    ./devtools.nix
    ./tmux
    ./pi
  ];

  skr.home = {
    lua.enable = true;
    neovim.enable = true;
    devtools.enable = true;
    tmux.enable = true;
    pi.enable = true;
  };

  home = {
    inherit username homeDirectory;
    stateVersion = "24.11";

    packages = with pkgs; [
      zsh
      agenix
      nixd
      nixfmt
      cargo
      rust-analyzer
      claude-code
    ];

    file = {
      ".zshrc".source = mkSymlink ".zshrc";

      # TODO: local executables. There is an XDG standard for this,
      # $HOME/.local/bin, but home-manager doesn't support it. I've had these in
      # $HOME/bin for now, but would be nice to have them in a standard place.
      "bin".source = mkSymlink "bin";
    };
  };

  age = {
    identityPaths = [ "${homeDirectory}/.ssh/id_ed25519" ];
  };

  programs.home-manager.enable = true;
}
