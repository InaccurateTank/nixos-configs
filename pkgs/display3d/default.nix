{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "display3d";
  version = "0.1.14";

  src = fetchFromGitHub {
    owner = "redpenguinyt";
    repo = "display3d";
    rev = "89ef110";
    hash = "sha256-UX6qliWyUkkqAEkXH2sVb4yXb1LV5B9V3x2AChDXops=";
  };

  cargoPatches = [
    ./lockfile.patch
  ];

  cargoHash = "sha256-s4JWxmsdLrfTMbWwxHH9inmopLgTedXHJzH99UVytdw=";

  postInstall = ''
    mkdir -p $out/share/resources
    cp ./resources/* $out/share/resources
  '';

  meta = with lib; {
    homepage = "https://github.com/redpenguinyt/display3d";
    description = "A command line interface for rendering and animating 3D objects";
  };
}
