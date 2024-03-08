{
  stdenvNoCC,
  fetchFromGitHub
}:
stdenvNoCC.mkDerivation rec {
  pname = "horizon-theme";
  version = "unstable-2024-03-07";

  src = fetchFromGitHub {
    owner = "zoddDev";
    repo = "Horizon";
    rev = "d4f25b5";
    hash = "";
  };

  installPhase = ''
    mkdir -p $out/share/themes/
    cp ${src}/.themes/horizon-theme $out/share/themes
  '';
}
