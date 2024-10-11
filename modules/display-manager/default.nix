{
  pkgs,
  lib,
  config,
  user,
  wallpaper,
  ...
}:
with lib; let
  cfg = config.modules.display-manager;
in {
  options.modules.display-manager = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable the sddm display manager.";
    };
    greeter = mkOption {
      type = with types; enum ["sddm" "greetd"];
      default = "sddm";
      description = "The greeter that will be used.";
    };
    autologin = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable autologin for the current user.";
      };
    };
    theme = {
      package = mkOption {
        type = types.package;
        default = pkgs.sddm-glassy;
        description = "The package that contain the theme.";
      };
      name = mkOption {
        type = types.str;
        default = "sddm-glassy";
        description = "The name of the package. It is the name of the folder within /share/sddm/themes.";
      };
      extraPackages = mkOption {
        type = with types; listOf package;
        default = with pkgs.libsForQt5; [
          qt5.qtgraphicaleffects
          plasma-workspace
          plasma-framework
          kconfig
        ];
        description = "Extra Qt plugins and/or QML libraries to add to the environment.";
      };
    };
    autoNumlock = mkOption {
      type = types.bool;
      default = true;
      description = "Enable numlock at login";
    };
  };
  config = mkIf cfg.enable (mkMerge [
    {
      environment.systemPackages = [cfg.theme.package];
      programs.hyprland = {
        enable = true;
        xwayland.enable = true;
      };
      boot.plymouth.enable = true;
    }
    (mkIf (cfg.greeter == "sddm") {
      services.displayManager.sddm = {
        enable = true;
        extraPackages = cfg.theme.extraPackages;
        theme = cfg.theme.name;
        wayland.enable = true;
        autoNumlock = cfg.autoNumlock;
      };
    })
    (mkIf (cfg.greeter == "greetd") {
      environment.etc = {
        "greetd/regreet.toml".source = import ./regreet.nix {inherit pkgs wallpaper;};
        # We use a home manager generator to define the hyprland configuration.
        # We need to define the text field instead of a file.
        "greetd/hyprland.conf".text = import ./hyprland.nix {inherit pkgs lib wallpaper;};
      };
      services.greetd = {
        enable = true;
        settings = {
          default_session = {
            command = "${lib.getExe config.programs.hyprland.package} --config /etc/greetd/hyprland.conf";
            # command = "${lib.getExe pkgs.cage} regreet";
            user = user;
          };
        };
      };
    })
  ]);
}
