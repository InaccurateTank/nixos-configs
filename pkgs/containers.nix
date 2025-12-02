{
  dockerTools,
  buildEnv,
  nodejs-slim_24,
  ...
}: {
  fvttNode = dockerTools.buildImage {
    name = "foundry-node";
    tag = "latest";

    copyToRoot = buildEnv {
      name = "image-root";
      paths = [nodejs-slim_24];
      pathsToLink = ["/bin"];
    };

    config = {
      Cmd = ["node" "/pkg/main.js" "--dataPath=/data"];
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
}
