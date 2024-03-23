# Modified from https://github.com/emilylange/nixos-config/blob/f49eaf2f1deca07eb0dc76d0ae426c9651b1d446/packages/caddy/default.nix
# Sourced from the discussion at https://github.com/NixOS/nixpkgs/pull/259275
{
  stdenv,
  buildGoModule,
  lib,
  caddy,
  xcaddy,
  go,
  cacert,
  plugins ? [],
  vendorHash ? null,
}:

caddy.override {
  buildGoModule = args: buildGoModule (args // {
    src = stdenv.mkDerivation {
      pname = "caddy-using-xcaddy-${xcaddy.version}";
      inherit (caddy) version;

      dontUnpack = true;
      dontFixup = true;

      nativeBuildInputs = [
        cacert
        go
      ];

      configurePhase = ''
        export GOCACHE=$TMPDIR/go-cache
        export GOPATH="$TMPDIR/go"
        export XCADDY_SKIP_BUILD=1
      '';

      buildPhase = ''
        ${xcaddy}/bin/xcaddy build "${caddy.src.rev}" ${lib.concatMapStringsSep " " (plugin: "--with ${plugin}") plugins}
        cd buildenv*
        go mod vendor
      '';

      installPhase = ''
        cp -r --reflink=auto . $out
      '';

      outputHash = if (vendorHash != null) then vendorHash else lib.fakeHash;
      outputHashMode = "recursive";
    };

    subPackages = [ "." ];
    ldflags = [ "-s" "-w" ]; ## don't include version info twice
    vendorHash = null;
  });
}
