pkgs: {
  custom-caddy = pkgs.caddy.withPlugins {
    plugins = ["github.com/caddy-dns/porkbun@v0.3.1"];
    hash = "sha256-NlZY/EEY9TbqrMAkSHK2aGm5AjFTvpvBXV1GW1PnXCc=";
  };
  container-images = {
    fvttNode = pkgs.dockerTools.buildImage {
      name = "foundry-node";
      tag = "latest";

      copyToRoot = pkgs.buildEnv {
        name = "image-root";
        paths = [ pkgs.nodejs-slim_24 ];
        pathsToLink = [ "/bin" ];
      };

      config = {
        Cmd = [ "node" "/pkg/main.js" "--dataPath=/data" ];
        WorkingDir = "/pkg";
        Volumes = {
          "/pkg" = {};
          "/data" = {};
        };
        ExposedPorts = {
          "30000:30000/tcp" = {};
        };
      };
    };
  };
}
