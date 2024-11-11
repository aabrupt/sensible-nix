_final: prev: {
  apple-color-emoji = prev.callPackage ./apple-color-emoji.nix {};
  hyprspace = prev.callPackage ./hyprspace.nix {};
  hyprkool-bin = prev.callPackage ./hyprkool-bin.nix {};
  hyprkool-plugin = prev.callPackage ./hyprkool-plugin.nix {};
  zen-browser = prev.callPackage ./zen-browser {};
  vimix-hyprcursor = prev.callPackage ./vimix-hyprcursor.nix {};
  sddm-glassy = prev.callPackage ./sddm-glassy {};
  unstable = prev.unstable // {zig = prev.callPackage ./zig {};};
}
