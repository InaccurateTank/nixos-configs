{
  lib,
  stdenv,
  fetchFromGitHub,
  php,
  fetchYarnDeps,
  yarnConfigHook,
  yarnBuildHook,
  nodejs,
  buildGoModule,
  ...
}: let
  panelName = "pelican-panel";
  panelVersion = "1.0.0-beta28";
  wingsVersion = "1.0.0-beta19";

  panelSrc = fetchFromGitHub {
    owner = "pelican-dev";
    repo = "panel";
    tag = "v${panelVersion}";
    hash = "sha256-uDpvElX+udlevUnncRepK8Vb71+TDsCTmlom1odHB70=";
  };

  pelican-php = php.buildEnv {
    extensions = {
      enabled,
      all,
    }:
      enabled
      ++ (with all; [
        gd
        mysqli
        mbstring
        bcmath
        curl
        zip
        intl
        sqlite3
      ]);
  };

  composeBuild = pelican-php.buildComposerProject2 {
    pname = "${panelName}-compose";
    version = panelVersion;

    src = panelSrc;

    php = pelican-php;

    passthru = {
      php = pelican-php;
    };

    vendorHash = "sha256-NLTq+9VcnnIdYNkIhn/SQwR2ayytLSGFRJzBqL4WEXU=";
  };
in {
  php = pelican-php;
  panel = stdenv.mkDerivation {
    pname = panelName;
    version = panelVersion;

    src = composeBuild;

    nativeBuildInputs = [
      yarnConfigHook
      yarnBuildHook
      nodejs
      pelican-php
    ];

    yarnOfflineCache = fetchYarnDeps {
      yarnLock = panelSrc + "/yarn.lock";
      hash = "sha256-VLero9gHqkh6svauRSwZf2ASpEBu9iQcPUx+J77SR+o=";
    };

    preConfigure = ''
      cd ./share/php/${composeBuild.pname}
    '';

    installPhase = ''
      rm -r node_modules
      mkdir -p $out/share/php/$pname
      cp -r ./ $out/share/php/$pname
    '';

    meta = {
      description = "Pelican Panel";
      homepage = "https://pelican.dev/";
      license = lib.licenses.agpl3Only;
      platforms = lib.platforms.linux;
    };
  };
  wings = buildGoModule {
    pname = "pelican-wings";
    version = wingsVersion;

    src = fetchFromGitHub {
      owner = "pelican-dev";
      repo = "wings";
      tag = "v${wingsVersion}";
      hash = "sha256-prjkFa4GbqChakMZ75GIexEN3C8W3s62V4/6xEfIWxg=";
    };

    vendorHash = "sha256-ozwgBvyu3Hnw0Zs54QnDUUBVuI+Hai8b7Yq9EWzqdfI=";

    meta = {
      description = "Pelican Wings";
      homepage = "https://pelican.dev/";
      license = lib.licenses.agpl3Only;
      platforms = lib.platforms.linux;
    };
  };
}
