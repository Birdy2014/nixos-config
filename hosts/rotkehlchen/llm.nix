{ config, pkgsUnstable, ... }:

{
  services.llama-cpp =
    let
      # https://github.com/NixOS/nixpkgs/issues/564449
      nixpkgs-old = fetchTarball {
        url = "https://releases.nixos.org/nixos/unstable/nixos-26.11pre1070770.8ce4ef6cb6f8/nixexprs.tar.zst";
        sha256 = "15p6r29c2qz8rch0a2ni5v1qfz9kjgrd4jklbj5qvqdagikrvqdb";
      };
      pkgsOld = import nixpkgs-old {
        system = "x86_64-linux";
      };
    in
    {
      enable = true;
      package = pkgsOld.llama-cpp-vulkan;
      port = 1112;
      modelsDir = "/run/media/moritz/archive/llama-models/autoload";
      extraFlags = [
      /*nixfmt:disable*/
      "--sleep-idle-seconds" "600"
      "--models-max" "1"
      "--parallel" "1"
      /*nixfmt:enable*/
      ];
      modelsPreset =
        let
          dir = "/run/media/moritz/archive/llama-models";
          modelMmprojOptions = model: mmproj: {
            model = "${dir}/${model}/${model}.gguf";
            mmproj = "${dir}/${model}/${mmproj}.gguf";
          };

          qwen3Options = {
            reasoning-preserve = false;
            reasoning-effort = "low";
          };

          gemma4Options = {
            # Needed for images to work with gemma 4
            ubatch-size = 2048;
          };
        in
        {
          "*" = {
            # https://github.com/ggml-org/llama.cpp/discussions/23470?utm_source=chatgpt.com
            cache-type-k = "q5_1";
            cache-type-v = "q5_1";

            flash-attn = "on";
            ctx-size = 100000;
            load-on-startup = "off";
            predict = 20000;
            mmproj-offload = false;
          };

          # Qwen 3.6
          "Cyber-Tiel-Coder-35B-A3B-UD-IQ4_XS" = qwen3Options // {
            model = "${dir}/Cyber-Tiel-Coder-35B-A3B-MTP-UD-IQ4_XS.gguf";
            spec-type = "draft-mtp";
          };

          # Qwen 3.8
          "Qwen3.8-27B-UD-IQ4_XS" = qwen3Options // {
            model = "${dir}/Qwen3.8-27B-UD-IQ4_XS.gguf";
          };
          "orcarouter_Qwen3.8-27B-Uncensored-IQ4_XS" = qwen3Options // {
            model = "${dir}/orcarouter_Qwen3.8-27B-Uncensored-IQ4_XS.gguf";
          };
          "Swift-Qwen3.8-27B-IQ4_XS" =
            qwen3Options // modelMmprojOptions "Swift-Qwen3.8-27B-IQ4_XS" "mmproj-Swift-Qwen3.8-27B-F16";
          "Swift-Qwen3.8-27B-Uncensored-UD-Q4_K_S" =
            qwen3Options
            // modelMmprojOptions "Swift-Qwen3.8-27B-Uncensored-Dynamic-MTP-UD-Q4_K_S" "mmproj-BF16";

          # Gemma 4
          "gemma-4-26B-A4B-it-UD-IQ4_XS" =
            gemma4Options // modelMmprojOptions "gemma-4-26B-A4B-it-UD-IQ4_XS" "mmproj-BF16";
          "Huihui-gemma-4-26B-A4B-it-qat-q4_0-abliterated-Q4_K" =
            gemma4Options
            // modelMmprojOptions "Huihui-gemma-4-26B-A4B-it-qat-q4_0-unquantized-abliterated-Q4_K" "mmproj-model-bf16";
        };
    };

  services.open-webui = {
    enable = true;
    port = 1111;
    environment = {
      ANONYMIZED_TELEMETRY = "False";
      DO_NOT_TRACK = "True";
      SCARF_NO_ANALYTICS = "True";
      ENABLE_VERSION_UPDATE_CHECK = "False";

      WEBUI_URL = "https://open-webui.rotkehlchen.mvogel.dev";
      ENABLE_OAUTH_SIGNUP = "true";
      OAUTH_MERGE_ACCOUNTS_BY_EMAIL = "true";
      OAUTH_CLIENT_ID = "hCbASFUm5FjbrxGM_KHaq1By_U0tYuwZDS_ZDKL5K4LcMmNpFZsmDnpXP5CNmS6XM1471O-N";
      OPENID_PROVIDER_URL = "https://auth.seidenschwanz.mvogel.dev/.well-known/openid-configuration";
      OAUTH_PROVIDER_NAME = "Authelia";
      OAUTH_SCOPES = "openid email profile groups";
      ENABLE_OAUTH_ROLE_MANAGEMENT = "true";
      OAUTH_ALLOWED_ROLES = "openwebui,openwebui-admin";
      OAUTH_ADMIN_ROLES = "openwebui-admin";
      OAUTH_ROLES_CLAIM = "groups";
      OAUTH_CODE_CHALLENGE_METHOD = "S256";
    };
    environmentFile = config.sops.secrets."open-webui-secrets".path;
  };

  my.proxy.domains.open-webui = {
    proxyPass = "http://localhost:1111";
    proxyWebsockets = true;
  };
}
