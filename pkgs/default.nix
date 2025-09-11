pkgs: {
  custom-caddy = pkgs.caddy.withPlugins {
    plugins = ["github.com/caddy-dns/porkbun@v0.3.1"];
    hash = "sha256-PUHu+KPywdJMuPLHPtQhUaw3Cv1pED5XQ1MOzlT/6h4=";
  };
}
