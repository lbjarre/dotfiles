{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.skr.home.neovim;

  dotfiles = "${config.home.homeDirectory}/src/github.com/lbjarre/dotfiles";
  mkSymlink = config.lib.file.mkOutOfStoreSymlink;

  # Fetches a docset for the Fennel language server to understand nvim modules.
  #
  # Docs: https://dev.fennel-lang.org/wiki/LanguageServer
  nvimDocset = pkgs.fetchgit {
    url = "https://git.sr.ht/~micampe/fennel-ls-nvim-docs";
    rev = "8d354237295c5d14e2b560ad73737a2e15550f19";
    hash = "sha256-H9EnwkgkLADx+5Xkr8OiZVBQuZR2+yuUsq8zIa7s8aY=";
    sparseCheckout = [ "nvim.lua" ];
  };
in
{
  options.skr.home.neovim = {
    enable = lib.mkEnableOption "Enable neovim";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.neovim ];

    xdg = {
      enable = true;
      configFile.nvim.source = mkSymlink "${dotfiles}/nvim";
      dataFile."fennel-ls/docsets/nvim.lua".source = "${nvimDocset}/nvim.lua";
    };
  };
}
