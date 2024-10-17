{
  pkgs,
  lib,
  config,
  nvim-config,
  ...
}:
with lib; let
  cfg = config.modules.nvim;
in {
  options.modules.nvim = {enable = mkEnableOption "nvim";};
  config = mkIf cfg.enable {
    home.packages = with pkgs.unstable; [
      neovim

      # Rust build systems
      rustup
      cargo-info
      tailwindcss

      # Package managers
      yarn

      # Programming languages
      nodejs_22
      go
      ocaml
      zig

      # Erlang
      gleam
      erlang
      rebar3
      elixir

      # Python
      # ruff
      # pylyzer
      python312Packages.python-lsp-server
      python312Packages.pylsp-rope

      # Lsp
      lua-language-server
      nil
      elixir-ls
      tailwindcss-language-server
      zls
      superhtml
      htmx-lsp

      # Linters
      eslint_d

      # Formatters
      stylua
      alejandra
    ];

    home.sessionVariables = {
      EDITOR = "nvim";
      MANPAGER = "nvim +Man!";
      MANWIDTH = 999;
    };

    xdg.configFile."nvim" = {
      # The configuration is managed through the flake and passed into home-manager as an argument
      source = nvim-config;
      recursive = true;
    };
  };
}
