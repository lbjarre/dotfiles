{ pkgs, ... }:
let
  name = "skr";
in
{
  users.users.${name} = {
    inherit name;
    home = "/Users/${name}";
    isHidden = false;
    shell = pkgs.zsh;
  };

  environment.systemPackages = with pkgs; [
    neovim
    atuin
    bat
    eza
    fzf
    zoxide
    tmux
    direnv
    starship
    wezterm
    firefox
    aerospace
    spotify
    wttr
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.caskaydia-cove
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;
  system.primaryUser = name;

  system.defaults = {
    dock = {
      orientation = "bottom";
      # Autohide the dock, more screen real estate.
      autohide = true;
      # Persistent apps in the dock.
      persistent-apps = [
        { app = "/Applications/Nix Apps/Firefox.app"; }
        { app = "/Applications/Nix Apps/WezTerm.app"; }
        { app = "/Applications/Nix Apps/AeroSpace.app"; }
        { app = "/Applications/Nix Apps/Spotify.app"; }
      ];
    };

    # Turn off "natural" scroll direction.
    NSGlobalDomain."com.apple.swipescrolldirection" = false;

    finder = {
      # Show hidden files.
      AppleShowAllFiles = true;
      # Show file extensions.
      AppleShowAllExtensions = true;
      # Don't warn when chaning file extensions.
      FXEnableExtensionChangeWarning = false;
      # Show path breadcrumb.
      ShowPathbar = true;
    };

    # Show more controls in menu bar by default.
    controlcenter = {
      Bluetooth = true;
      Sound = true;
    };
  };

  # Enable sudo with TouchID.
  security.pam.services.sudo_local = {
    enable = true;
    reattach = true;
    touchIdAuth = true;
  };

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;
}
