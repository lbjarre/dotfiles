{
  agenix,
  pkgs,
  ...
}:
{
  imports = [
    agenix.homeManagerModules.default
    ./skr.nix
  ];

  skr.home = {
    enable = true;

    pi.enable = false;
  };

  home = {
    stateVersion = "24.11";

    packages = with pkgs; [
      go
      gopls

      rust-analyzer

      kubectl

      ansible
      vault
    ];
  };
}
