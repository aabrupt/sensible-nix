{
  config,
  lib,
  ...
}: let
  cfg = config.modules.fish;
in {
  options.modules.fish = {enable = lib.mkEnableOption "fish";};

  config = lib.mkIf cfg.enable {
    programs.fish = {
      enable = true;

      shellAliases = {
        rm = "trash put";
        ls = "eza";
      };

      shellAbbrs = {
        nvim-dev = "NVIM_APPNAME=nvim-dev nvim";
        ll = "ls -ahl";
        lt = "ls -hlTL 5";
        speedtest = "speedtest-rs";
        st = "speedtest-rs";
        printpath = "printf %s\\n $PATH | column";
        systempath = "printf %s\\n $PATH | grep -v /mnt | column";
      };

      shellInit = ''
        fish_vi_key_bindings

        function storePathForWindowsTerminal --on-variable PWD
          if test -n "$WT_SESSION"
            printf "\e]9;9;%s\e\\" (wslpath -w "$PWD")
          end
        end

        function take
          mkdir -p $argv && cd $argv
        end

        function clear
          command clear
          if test (tput cols) -ge 80
            fastfetch
          end
        end

        function custom_tab_completion
            if test (commandline -c) -eq 0
                # Do nothing if the command line is empty
                return 0
            else
                # Perform the default tab completion
                commandline -f complete
            end
        end

        bind \t custom_tab_completion

        fish_config theme choose Nord
      '';

      interactiveShellInit = ''
        clear
        set fish_greeting # Disable greeting
      '';
    };
  };
}
