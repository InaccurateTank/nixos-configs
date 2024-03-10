{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation rec {
  pname = "horizon-theme";
  version = "unstable-2024-03-07";

  src = fetchFromGitHub {
    owner = "zoddDev";
    repo = "Horizon";
    rev = "d4f25b5";
    hash = "sha256-gwREyPG5SnjVTpx1Po4Ie0+3cWww4KNyWbKbJjPWtWg=";
  };

  installPhase = ''
    mkdir -p $out/share/themes/
    cp -r ${src}/.themes/horizon-theme $out/share/themes
  '';

  meta = with lib; {
    homepage = "https://github.com/zoddDev/Horizon/tree/master/.themes/horizon-theme";
    description = "Shamelessly ripped from someones precious dotfiles";
    license = licenses.gpl2Only;
  };
}
