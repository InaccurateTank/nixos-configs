{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:
buildGoModule (finalAttrs: {
  pname = "pelican-wings";
  version = "1.0.0-rc1";

  src = fetchFromGitHub {
    owner = "pelican-dev";
    repo = "wings";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5nAfzczYUqxZpTfHYpGfQgcue2gzkcOczT9brx6auOY=";
  };

  vendorHash = "sha256-ozwgBvyu3Hnw0Zs54QnDUUBVuI+Hai8b7Yq9EWzqdfI=";

  meta = {
    description = "Pelican Wings";
    homepage = "https://pelican.dev/";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.linux;
  };
})
