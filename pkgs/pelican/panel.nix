{
  lib,
  stdenv,
  fetchFromGitHub,
  php,
  fetchYarnDeps,
  yarnConfigHook,
  yarnBuildHook,
  nodejs,
  dataDir ? "/var/lib/pelican/panel",
  runtimeDir ? "/run/pelican-panel"
}: let
  pname = "pelican-panel";
  version = "1.0.0-rc.2";

  src = fetchFromGitHub {
    owner = "pelican-dev";
    repo = "panel";
    tag = "v${version}";
    hash = "sha256-m2WMlQBdH3M1uBXtIzWtYx+60ho3ZFBH9ssHlEOu2vA=";
  };

  composeBuild = php.buildComposerProject2 {
    inherit version src;
    pname = "${pname}-composer";
    vendorHash = "sha256-5BGQX6dXv8lEIVGi5so71jmbMM5sDYFQFlX67XgkiDs=";
  };
in stdenv.mkDerivation {
  inherit pname version;

  src = composeBuild;

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    nodejs
  ];

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = src + "/yarn.lock";
    hash = "sha256-EVbyxhZhe6rKYY65HrU0fqE6m/tzKY7mjdgYvDDj8po=";
  };

  preConfigure = ''
    cd ./share/php/${composeBuild.pname}
  '';

  installPhase = ''
    # Finalizing install
    rm -r node_modules
    mkdir $out
    mv ./* $out
    rm -r $out/bootstrap/cache
    cp ${src}/.env.example $out/.env.example

    echo "creating static folders"
    mv $out/bootstrap $out/bootstrap-static
    mv $out/storage $out/storage-static
    mv $out/database $out/database-static

    echo "linking deployment folders"
    ln -s ${dataDir}/.env $out/.env
    ln -s ${runtimeDir} $out/bootstrap
    ln -s ${dataDir}/storage $out/
    ln -s ${dataDir}/database $out/

    echo "linking storage"
    ln -sf ${dataDir}/storage/app/public $out/public/storage
    ln -s ${dataDir}/storage/avatars $out/public/avatars
    ln -s ${dataDir}/storage/fonts $out/public/fonts
  '';

  meta = {
    description = "Pelican Panel";
    homepage = "https://pelican.dev/";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.linux;
  };
}
