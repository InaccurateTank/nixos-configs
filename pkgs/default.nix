pkgs: let
  containers = import ./containers.nix pkgs;
  pelican = import ./pelican.nix pkgs;
in {
  custom-caddy = pkgs.caddy.withPlugins {
    plugins = ["github.com/caddy-dns/porkbun@v0.3.1"];
    hash = "sha256-NlZY/EEY9TbqrMAkSHK2aGm5AjFTvpvBXV1GW1PnXCc=";
  };

  container-fvttNode = containers.fvttNode;

  pelican-php = pelican.php;
  pelican-panel = pelican.panel;
  pelican-wings = pelican.wings;
}
