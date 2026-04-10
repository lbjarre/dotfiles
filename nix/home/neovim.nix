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
    rev = "c2a6d73162d0c0d6718980267b416ec16530dcd9";
    hash = "sha256-NclEX7mbo+LVR+7WCCshAGsYY70HnFz9bRrP4mi/TT0=";
    sparseCheckout = [ "nvim.lua" ];
  };
in
{
  options.skr.home.neovim = {
    enable = lib.mkEnableOption "Enable neovim";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.neovim
      # Get tree-sitter to allow for :TSInstall to work.
      # TODO: manage ts grammars via nix instead.
      pkgs.tree-sitter
    ];

    xdg = {
      enable = true;
      configFile.nvim.source = mkSymlink "${dotfiles}/nvim";
      dataFile."fennel-ls/docsets/nvim.lua".source = "${nvimDocset}/nvim.lua";
    };
  };
}
