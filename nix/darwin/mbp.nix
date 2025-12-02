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
    wttr
  ];

  homebrew = {
    enable = true;
    casks = [
      "spotify"
    ];
    global.brewfile = true;
    onActivation.cleanup = "zap";
  };

  fonts.packages = with pkgs; [
    hack-font
    nerd-fonts.hack
    fira-code
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  system.primaryUser = "skr";

  system.defaults = {
    # Autohide the dock, more screen real estate.
    dock.autohide = true;

    # Turn off "natural" scroll direction.
    NSGlobalDomain."com.apple.swipescrolldirection" = false;

    finder = {
      AppleShowAllExtensions = true;
      ShowPathbar = true;
      FXEnableExtensionChangeWarning = false;
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
