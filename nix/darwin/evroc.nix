{ pkgs, ... }:
{
  users.users.skr = {
    name = "skr";
    home = "/Users/skr";
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
    fira-code
  ];

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.enable = false;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;
}
