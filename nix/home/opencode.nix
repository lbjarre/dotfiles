{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.skr.home.opencode;
in
{
  options.skr.home.opencode = {
    enable = lib.mkEnableOption "Enable opencode";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.opencode
      pkgs.lsof # needed by the nvim plugin
    ];

    xdg = {
      enable = true;
      configFile."opencode/opencode.json".text = builtins.toJSON {
        "$schema" = "https://opencode.ai/config.json";
        autoupdate = false;
        provider = {
          evroc = {
            npm = "@ai-sdk/openai-compatible";
            name = "evroc";
            options = {
              baseURL = "https://models.think.cloud.evroc.com/v1";
              apiKey = "{file:${config.age.secrets.evroc-think-devstral.path}}";
            };
            models = {
              "mistralai/Devstral-Small-2-24B-Instruct-2512" = {
                name = "evroc think devstral";
                limit.output = 50000;
                limit.context = 32000;
              };
            };
          };
        };
      };
    };

    age.secrets.evroc-think-devstral = {
      file = ../secrets/evroc-think-devstral.age;
      path = "${config.home.homeDirectory}/.secrets/EVROC_THINK_DEVSTRAL_API_KEY";
    };
  };
}
