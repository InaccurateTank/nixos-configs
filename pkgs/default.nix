pkgs: let
  containers = import ./containers.nix pkgs;
in {
  custom-caddy = pkgs.caddy.withPlugins {
    plugins = ["github.com/caddy-dns/porkbun@v0.3.1"];
    hash = "sha256-NlZY/EEY9TbqrMAkSHK2aGm5AjFTvpvBXV1GW1PnXCc=";
  };

  container-fvttNode = containers.fvttNode;

  pelican-php = pkgs.php.buildEnv {
    extensions = {
      enabled,
      all,
    }:
      enabled
      ++ (with all; [
        gd
        mysqli
        mbstring
        bcmath
        curl
        zip
        intl
        sqlite3
      ]);
  };
  pelican-panel = pkgs.callPackage ./pelican/panel.nix {};
  pelican-wings = pkgs.callPackage ./pelican/wings.nix {};
}
