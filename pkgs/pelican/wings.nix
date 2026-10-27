{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:
buildGoModule (finalAttrs: {
  pname = "pelican-wings";
  version = "1.0.0-rc.1";

  src = fetchFromGitHub {
    owner = "pelican-dev";
    repo = "wings";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TErlxIXSlmxPaEQLLqcHUm+Sum+pjI8hYve0CWpc6hc=";
  };

  vendorHash = "sha256-2Hs1SfCsf5JYIIRC0VHlfVzRx2e+xrSotqrfbCqMogo=";

  meta = {
    description = "Pelican Wings";
    homepage = "https://pelican.dev/";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.linux;
  };
})
