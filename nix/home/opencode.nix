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
            name = "evroc Think";
            options = {
              baseURL = "https://models.think.cloud.evroc.com/v1";
              apiKey = "{file:${config.age.secrets.evroc-think-devstral.path}}";
            };
            models = {
              "mistralai/Devstral-Small-2-24B-Instruct-2512" = {
                name = "mistralai/Devstral-Small-2-24B-Instruct-2512";
                limit.context = 32000;
                limit.output = 50000;
              };
              "moonshotai/Kimi-K2-Thinking" = {
                name = "moonshotai/Kimi-K2-Thinking";
                limit.context = 100000;
                limit.output = 50000;
              };
              "moonshotai/Kimi-K2.5" = {
                name = "moonshotai/Kimi-K2.5";
                limit.context = 200000;
                limit.output = 56000;
              };
              "Qwen/Qwen3-30B-A3B-Instruct-2507-FP8" = {
                name = "Qwen/Qwen3-30B-A3B-Instruct-2507-FP8";
                limit.context = 440000;
                limit.output = 20000;
              };
              "openai/gpt-oss-120b" = {
                name = "openai/gpt-oss-120b";
                limit.context = 40000;
                limit.output = 25000;
              };
              "microsoft/Phi-4-multimodal-instruct" = {
                name = "microsoft/Phi-4-multimodal-instruct";
                limit.context = 20000;
                limit.output = 10000;
              };
              "mistralai/Magistral-Small-2509" = {
                name = "mistralai/Magistral-Small-2509";
                limit.context = 10000;
                limit.output = 10000;
              };
              "mistralai/Voxtral-Small-24B-2507" = {
                name = "mistralai/Voxtral-Small-24B-2507";
                limit.context = 10000;
                limit.output = 10000;
              };
              "nvidia/Llama-3.3-70B-Instruct-FP8" = {
                name = "nvidia/Llama-3.3-70B-Instruct-FP8";
                limit.context = 128000;
                limit.output = 20000;
              };
            };
          };
        };
        small_model = "Qwen/Qwen3-30B-A3B-Instruct-2507-FP8";
      };
    };

    age.secrets.evroc-think-devstral = {
      file = ../secrets/evroc-think-api-key.age;
      path = "${config.home.homeDirectory}/.secrets/EVROC_THINK_API_KEY";
    };
  };
}
