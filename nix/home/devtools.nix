# A potpourri of various programs for general development, plus any
# configuration for them.
{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.skr.home.devtools;

  dotfiles = "${config.home.homeDirectory}/src/github.com/lbjarre/dotfiles";
  mkSymlink = p: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${p}";
in
{
  options.skr.home.devtools = {
    enable = lib.mkEnableOption "Enable devtools";

    atuin-hex = lib.mkOption {
      description = ''
        Whether to enable the hex feature in the atuin crate, which uses a pty
        proxy to draw the Ctrl-R overlay.

        Currently turned off by default since it does not work well when
        running in an embedded terminal in a neovim split.
      '';
      type = lib.types.bool;
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      git
      jujutsu
      ripgrep
      fzf
      (
        let
          patched = atuin.overrideAttrs (old: {
            cargoBuildFeatures = (old.cargoBuildFeatures or [ ]) ++ [ "hex" ];
          });
          pkg = if cfg.atuin-hex then patched else pkgs.atuin;
        in
        pkg
      )
      bat
      zoxide
      eza
      fd
      starship
      coreutils
      difftastic
      delta
      mergiraf
      direnv
      bottom
      entr
      wezterm
      uv
      buf
      yamlfmt
    ];

    xdg = {
      enable = true;
      configFile = {
        "git".source = mkSymlink "config/git";
        "jj/config.toml".source = mkSymlink "config/jj/config.toml";
        "atuin".source = mkSymlink "config/atuin";
        "starship.toml".source = mkSymlink "config/starship.toml";
        "wezterm".source = mkSymlink "config/wezterm";
      };
    };
  };
}
