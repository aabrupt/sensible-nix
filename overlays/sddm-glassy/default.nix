{stdenvNoCC}:
stdenvNoCC.mkDerivation rec {
  name = "sddm-glassy";
  src = ./.;

  dontWrapQtApps = true;

  installPhase = ''
    mkdir -p $out/share/sddm/themes
    cp -r $src $out/share/sddm/themes/${name}

    mkdir -p $out/nix-support
  '';
}
