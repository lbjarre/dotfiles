{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.skr.home.lua;
in
{
  options.skr.home.lua = {
    enable = lib.mkEnableOption "Enable Lua/Fennel packages";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      lua
      lua-language-server
      stylua
      luaPackages.fennel
      fennel-ls
      fnlfmt
    ];
  };
}
