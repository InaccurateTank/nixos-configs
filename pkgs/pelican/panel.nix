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
  version = "1.0.0-beta28";

  src = fetchFromGitHub {
    owner = "pelican-dev";
    repo = "panel";
    tag = "v${version}";
    hash = "sha256-uDpvElX+udlevUnncRepK8Vb71+TDsCTmlom1odHB70=";
  };

  composeBuild = php.buildComposerProject2 {
    inherit version src;
    pname = "${pname}-composer";
    vendorHash = "sha256-NLTq+9VcnnIdYNkIhn/SQwR2ayytLSGFRJzBqL4WEXU=";
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
    hash = "sha256-VLero9gHqkh6svauRSwZf2ASpEBu9iQcPUx+J77SR+o=";
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

    echo "linking deployment folders"
    ln -s ${dataDir}/.env $out/.env
    ln -s ${dataDir}/database/database.sqlite $out/database/database.sqlite
    ln -s ${dataDir}/storage $out/
    ln -s ${runtimeDir} $out/bootstrap

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
