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
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      git
      jujutsu
      ripgrep
      fzf
      atuin
      bat
      zoxide
      eza
      starship
      coreutils
      difftastic
      delta
      mergiraf
      direnv
      bottom
      tmux
      entr
      wezterm
      uv
    ];

    xdg = {
      enable = true;
      configFile = {
        "git".source = mkSymlink "config/git";
        "jj".source = mkSymlink "config/jj";
        "atuin".source = mkSymlink "config/atuin";
        "starship.toml".source = mkSymlink "config/starship.toml";
        "tmux".source = mkSymlink "config/tmux";
        "wezterm".source = mkSymlink "config/wezterm";
      };
    };
  };
}
