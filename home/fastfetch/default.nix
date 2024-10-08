{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.fastfetch;
in {
  options.modules.fastfetch = {
    enable = mkOption {
      type = types.bool;
      default = config.modules.fish.enable;
    };
  };
  config = mkIf cfg.enable {
    programs.fastfetch.enable = true;

    xdg.configFile."fastfetch/config.jsonc".source = ./fastfetch.jsonc;
  };
}
