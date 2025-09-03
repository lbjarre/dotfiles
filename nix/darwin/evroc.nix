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
    jq
    tmux

    go
    gopls

    clang-tools
  ];

  homebrew = {
    enable = true;
    casks = [
      "wezterm"
      "spotify"
    ];
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
  nix.enable = false;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;
  system.primaryUser = name;

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
