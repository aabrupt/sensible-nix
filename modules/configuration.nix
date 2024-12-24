{
  user,
  config,
  lib,
  pkgs,
  ssh,
  full-name,
  ...
}: {
  environment.defaultPackages = [];
  services.xserver.desktopManager.xterm.enable = false;

  # Ensure fish is enabled for user even if the configuration is inactive
  programs.fish.enable = true;

  # User
  users.users.${user} = {
    uid = 1000;
    isNormalUser = true;
    home = "/home/${user}";
    createHome = true;
    description = full-name;
    extraGroups = ["wheel" "networkmanager"];
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = ssh.users;
  };

  users.users.root.openssh.authorizedKeys.keys = ssh.users;

  # Locale settings
  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = ["en_US.UTF-8/UTF-8"];
    extraLocaleSettings = {
      LANGUAGE = "en_US.UTF-8";
      LOCALE_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";
    };
  };

  # Set up a font for the tty
  console = {
    font = "Lat2-Terminus16";
    keyMap = "sv-latin1";
  };

  # Set a timezone
  time.timeZone = lib.mkDefault "Europe/Stockholm";

  # Font settings
  fonts = {
    packages = with pkgs; [
      # Add all fonts to be installed here
      (nerdfonts.override {fonts = ["SourceCodePro"];})
    ];

    fontconfig.defaultFonts = {
      serif = [
        "SourceCodePro Nerd Font"
      ];
      sansSerif = [
        "SauceCodePro Nerd Font"
      ];
      monospace = [
        "SauceCodePro Nerd Font"
      ];
    };
  };

  # Wayland stuff: enable XDG integration, allow sway to use brillo
  xdg = {
    portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = with pkgs; [xdg-desktop-portal-gtk];
    };
  };

  nix = {
    settings.auto-optimise-store = true;
    settings.allowed-users = [user];
    settings.experimental-features = ["nix-command" "flakes"];
    settings.keep-outputs = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 2d";
    };
    extraOptions = ''
      !include ${config.age.secrets.nix-access-tokens.path}
    '';
  };

  # Boot settings
  boot.tmp.cleanOnBoot = true;

  # Set environment variables
  environment.variables = {
    XDG_CONFIG_HOME = "$HOME/.config";
    SHELL = lib.getExe pkgs.fish;
    DIRENV_LOG_FORMAT = "";
    ANKI_WAYLAND = "1";
    OZ_ENABLE_WAYLAND = "1";
    DISABLE_QT5_COMPAT = "0";
    NIXOS_OZONE_WL = "1";
  };

  # Security
  security = {
    sudo = {
      enable = true;
      wheelNeedsPassword = true;
      extraConfig = ''
        Defaults env_keep += "EDITOR"
        Defaults env_keep += "XDG_CONFIG_HOME"
        Defaults env_keep += "SSH_HOME"
        Defaults env_keep += "XDG_RUNTIME_DIR"

        Defaults insults
      '';
    };

    protectKernelImage = true;
  };

  hardware.pulseaudio.enable = true;
  security.rtkit.enable = true;

  services.pipewire = {
    enable = false;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable bluetooth, enable pulseaudio, enable opengl (for Wayland)
  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      hsphfpd.enable = true;
      settings = {
        General = {
          MultiProfile = "multiple";
        };
      };
    };
    graphics = lib.mkMerge [
      {
        enable = true;
        extraPackages = with pkgs; [
          vaapiVdpau
          libvdpau-va-gl
        ];
      }
      (lib.mkIf pkgs.stdenv.isx86_64 {
        extraPackages = with pkgs; [intel-media-driver];
      })
    ];
  };

  # SSH
  services.openssh = {
    enable = true;
    ports = [22];
    settings.PasswordAuthentication = false;
  };

  # Do not touch
  system.stateVersion = "23.11";
}
