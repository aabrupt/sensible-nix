{
  pkgs,
  lib,
  config,
  full-name,
  ...
}:
with lib; let
  cfg = config.modules.git;
in {
  options.modules.git = {enable = mkEnableOption "git";};
  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      userName = full-name;
      userEmail = "ludvigkallqvistnygren@gmail.com";
      extraConfig = {
        core.editor = "nvim";
        safe.directory = [
          "/etc/nixos"
        ];
        push.autoSetupRemote = true;
      };
    };
  };
}
