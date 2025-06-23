pkgs: {
  custom-caddy = pkgs.caddy.withPlugins {
    plugins = ["github.com/caddy-dns/porkbun@v0.2.1"];
    hash = "sha256-ayd1WnjBjQOIXtiCkR/aWML2Nc4eRyuTugsjHXOU5uQ=";
  };
}
