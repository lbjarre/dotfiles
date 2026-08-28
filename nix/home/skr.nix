{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isLinux;
  cfg = config.skr.home;
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

  options.skr.home = {
    enable = lib.mkEnableOption "skr home module";

    username = lib.mkOption {
      default = "skr";
      type = lib.types.str;
      description = ''
        Username of the user managed by this module.
      '';
    };

    homeDirectory = lib.mkOption {
      default =
        let
          root = if isLinux then "home" else "Users";
        in
        "/${root}/${cfg.username}";
      type = lib.types.str;
      description = ''
        Absolute path to the home directory of the user.
      '';
    };

    dotfilesDirectory = lib.mkOption {
      default = "${cfg.homeDirectory}/src/github.com/lbjarre/dotfiles";
      type = lib.types.str;
      description = ''
        Absolute path to where the dotfiles are checked out. Needed to maintain
        symlinks to config files in the dotfile repo, instead of baking them
        into the nix store.

        Defaults to a GOPATH-esque checkout from the home directory:
        ~/src/github.com/lbjarre/dotfiles.
      '';
    };

    manageNix = lib.mkOption {
      default = isLinux;
      type = lib.types.bool;
      description = ''
        Enable programs.nix.

        Darwin hosts are managed by Determinate Nix (for now).
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    skr.home = {
      lua.enable = lib.mkDefault true;
      neovim.enable = lib.mkDefault true;
      devtools.enable = lib.mkDefault true;
      tmux.enable = lib.mkDefault true;
      pi.enable = lib.mkDefault true;
    };

    home = {
      inherit (cfg) username homeDirectory;

      packages = [
        pkgs.zsh
        pkgs.nixd
        pkgs.nixfmt
      ];

      sessionVariables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
      };
    };

    age.identityPaths = [ "${cfg.homeDirectory}/.ssh/id_ed25519" ];

    nix = {
      enable = cfg.manageNix;
      package = pkgs.nix;
      settings.experimental-features = [
        "nix-command"
        "flakes"
      ];
      settings.trusted-users = [
        cfg.username
        "root"
      ];
    };

    programs.home-manager.enable = true;

    programs.zsh = {
      enable = true;
      dotDir = "${config.xdg.configHome}/zsh";

      autosuggestion.enable = true;

      initContent = ''
        # Source user config from dotfiles repo.
        source ${cfg.dotfilesDirectory}/.zshrc
      '';
    };

    services.ssh-agent.enable = lib.mkDefault true;
  };
}
