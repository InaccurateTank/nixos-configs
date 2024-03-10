# Basically just a simpler port of the primary nix module due to versioning stuff
{
  stdenv,
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  ttfautohint-nox,
  darwin,
  set ? null,
}: let
  buildPlan = ./private-build-plans.toml;
in
  buildNpmPackage rec {
    pname =
      if set != null
      then "iosevka-tonk-${set}"
      else "iosevka-tonk";
    version = "28.1.0";

    src = fetchFromGitHub {
      owner = "be5invis";
      repo = "iosevka";
      rev = "v${version}";
      hash = "sha256-cYnGJ7Z0PDRZtC/vz8hX/+mqk7iVkajFTfNGgRW+edQ=";
    };

    npmDepsHash = "sha256-bzQ7dc7UiC++0DxnQHusu6Ym7rd7GgeA6bGSnnla1nk=";

    nativeBuildInputs =
      [
        ttfautohint-nox
      ]
      ++ lib.optionals stdenv.isDarwin [
        # libtool
        darwin.cctools
      ];

    configurePhase = ''
      runHook preConfigure
      cp ${buildPlan} private-build-plans.toml
      runHook postConfigure
    '';

    buildPhase = ''
      export HOME=$TMPDIR
      runHook preBuild
      npm run build --no-update-notifier -- --jCmd=$NIX_BUILD_CORES --verbose=9 ttf::$pname
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      install -D -t $out/share/fonts/truetype dist/$pname/TTF/*
      runHook postInstall
    '';

    enableParallelBuilding = true;

    meta = with lib; {
      homepage = "https://typeof.net/Iosevka/";
      description = "Custom build of Iosevka using rounded characters similar to Iosevka Comfy. Not intended for public use.";
      license = licenses.ofl;
    };
  }
