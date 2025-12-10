{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:
buildGoModule (finalAttrs: {
  pname = "pelican-wings";
  version = "1.0.0-beta20";

  src = fetchFromGitHub {
    owner = "pelican-dev";
    repo = "wings";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Pwv20qjY6yE3kpKsXDViS5EznrmuIFgzFTCSuCnQyq8=";
  };

  vendorHash = "sha256-ozwgBvyu3Hnw0Zs54QnDUUBVuI+Hai8b7Yq9EWzqdfI=";

  meta = {
    description = "Pelican Wings";
    homepage = "https://pelican.dev/";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.linux;
  };
})
