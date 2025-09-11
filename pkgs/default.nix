pkgs: {
  custom-caddy = pkgs.caddy.withPlugins {
    plugins = ["github.com/caddy-dns/porkbun@v0.3.1"];
    hash = "sha256-YZ4Bq0hfOJpa0C2lKipEY4fqwzJbEFM7ci5ys9S3uAo=";
  };
}
