pkgs: let
  callPackage = pkgs.callPackage;
in {
  iosevka-tonk = callPackage ./iosevka-tonk {};
  iosevka-tonk-term = callPackage ./iosevka-tonk {set = "term";};

  custom-caddy = callPackage ./custom-caddy.nix {
    externalPlugins = [
      {
        name = "porkbun";
        repo = "github.com/caddy-dns/porkbun";
        version = "v0.1.4";
      }
    ];
    vendorHash = "sha256-tR9DQYmI7dGvj0W0Dsze0/BaLjG84hecm0TPiCVSY2Y=";
  };

  horizon-theme = callPackage ./horizon-theme.nix {};
}
