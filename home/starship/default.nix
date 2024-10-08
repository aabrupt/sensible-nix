{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.starship;
in {
  options.modules.starship = {
    enable = mkOption {
      type = types.bool;
      default = config.modules.fish.enable;
    };
  };
  config = mkIf cfg.enable {
    programs.starship = {
      enable = true;
      enableFishIntegration = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      settings = {
        format = "$git_branch$username$directory$character";
        right_format = "$nix_shell$time";

        username = {
          disabled = false;
          show_always = true;
          format = "[$user]($style) ";
        };

        directory = {
          disabled = false;
          read_only = "󰌾 ";
          home_symbol = "󰋜 ";
        };

        nix_shell = {
          disabled = false;
          format = "[$symbol$state $name]($style)";
        };

        time = {
          disabled = true;
          format = "[$time]($style)";
        };

        git_branch = {
          disabled = false;
          format = "[$symbol$branch(:$remote_branch)]($style) ";
          symbol = "󰘬 ";
          always_show_remote = true;
        };
      };
    };
  };
}
