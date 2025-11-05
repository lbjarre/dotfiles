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
    rev = "3524319fb47f1da0d1046e2143385650ab37992a";
    hash = "sha256-GuYa0L9efemro7Q8mMkLqkWzxTqOiQf9rO0F+/89NjM=";
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
