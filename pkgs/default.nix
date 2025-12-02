pkgs: {
  custom-caddy = pkgs.caddy.withPlugins {
    plugins = ["github.com/caddy-dns/porkbun@v0.3.1"];
    hash = "sha256-NlZY/EEY9TbqrMAkSHK2aGm5AjFTvpvBXV1GW1PnXCc=";
  };
  container-images = import ./containers.nix pkgs;
  pelican = import ./pelican.nix pkgs;
}
