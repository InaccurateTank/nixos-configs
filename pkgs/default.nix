pkgs: {
  iosevka-tonk = pkgs.callPackage ./iosevka-tonk {};
  iosevka-tonk-term = pkgs.callPackage ./iosevka-tonk {set = "term";};

  cs-firewall-bouncer = pkgs.callPackage ./cs-firewall-bouncer.nix {};

  custom-caddy = pkgs.caddy.withPlugins {
    plugins = [ "github.com/caddy-dns/porkbun@v0.2.1" ];
    hash = "sha256-ayd1WnjBjQOIXtiCkR/aWML2Nc4eRyuTugsjHXOU5uQ=";
  };
}
