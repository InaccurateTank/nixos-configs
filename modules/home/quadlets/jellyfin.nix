{
  config,
  lib,
  ...
}: let
  cfg = config.flakeMods.quadlets.jellyfin;
in {
  options.flakeMods.quadlets.jellyfin.enable = lib.mkEnableOption "jellyfin mediaserver pod";

  config = lib.mkIf cfg.enable {
    virtualisation.quadlet = let
      inherit (config.virtualisation.quadlet) pods;
    in {
      pods.mediaserver = {
        autoStart = true;
        podConfig = {
          publishPorts = [
            "127.0.0.1:8096:8096/tcp"
            "127.0.0.1:8989:8989/tcp"
            "127.0.0.1:7878:7878/tcp"
            "127.0.0.1:5690:5690/tcp"
            "127.0.0.1:5055:5055/tcp"
            "127.0.0.1:9696:9696/tcp"
            "127.0.0.1:8191:8191/tcp"
            "127.0.0.1:6767:6767/tcp"
          ];
        };
      };
      containers.ms-jellyfin = {
        containerConfig = {
          image = "docker.io/jellyfin/jellyfin:latest";
          pod = pods.mediaserver.ref;
          user = "633:633";
          volumes = [
            "/srv/containers/mediaserver/config/jellyfin:/config:Z"
            "/srv/containers/mediaserver/cache:/cache:Z"
            "/mnt/data/mediaserver/media:/media:z"
          ];
        };
      };
    };
  };
}
