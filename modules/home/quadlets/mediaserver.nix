{
  config,
  lib,
  ...
}: let
  cfg = config.flakeMods.quadlets.mediaserver;
in {
  options.flakeMods.quadlets.mediaserver.enable = lib.mkEnableOption "jellyfin mediaserver pod";

  config = lib.mkIf cfg.enable {
    virtualisation.quadlet = let
      inherit (config.virtualisation.quadlet) containers pods;
    in {
      pods.mediaserver = {
        autoStart = true;
        podConfig = {
          publishPorts = [
            "127.0.0.1:8096:8096/tcp" # Jellyfin HTTP
            "127.0.0.1:8989:8989/tcp" # Sonarr
            "127.0.0.1:7878:7878/tcp" # Radarr
            # "127.0.0.1:5690:5690/tcp" Wizarr
            # "127.0.0.1:5055:5055/tcp" Jellyseer
            "127.0.0.1:9696:9696/tcp" # Prowlarr
            "127.0.0.1:8191:8191/tcp" # Flaresalverr
            "127.0.0.1:6767:6767/tcp" # Bazarr
          ];
        };
      };
      containers = {
        ms-jellyfin = {
          containerConfig = {
            image = "docker.io/jellyfin/jellyfin:latest";
            autoUpdate = "registry";
            pod = pods.mediaserver.ref;
            user = "633:633";
            volumes = [
              "/srv/containers/mediaserver/config/jellyfin:/config:Z"
              "/srv/containers/mediaserver/cache:/cache:Z"
              "/mnt/data/mediaserver/media:/media:z"
            ];
          };
        };
        ms-sonarr = {
          unitConfig = {
            After = [containers.ms-jellyfin.ref "network-online.target"];
            Requires = [containers.ms-jellyfin.ref "network-online.target"];
          };
          containerConfig = {
            image = "lscr.io/linuxserver/sonarr:latest";
            autoUpdate = "registry";
            pod = pods.mediaserver.ref;
            environments = {
              TZ = "America/Los_Angeles";
              PUID = "633";
              PGID = "633";
            };
            volumes = [
              "/srv/containers/mediaserver/config/sonarr:/config:Z"
              "/mnt/data/mediaserver:/data:z"
            ];
          };
        };
        ms-radarr = {
          unitConfig = {
            After = [containers.ms-jellyfin.ref "network-online.target"];
            Requires = [containers.ms-jellyfin.ref "network-online.target"];
          };
          containerConfig = {
            image = "lscr.io/linuxserver/radarr:latest";
            autoUpdate = "registry";
            pod = pods.mediaserver.ref;
            environments = {
              TZ = "America/Los_Angeles";
              PUID = "633";
              PGID = "633";
            };
            volumes = [
              "/srv/containers/mediaserver/config/radarr:/config:Z"
              "/mnt/data/mediaserver:/data:z"
            ];
          };
        };
        ms-prowlarr = {
          unitConfig = {
            After = [containers.ms-sonarr.ref containers.ms-radarr.ref "network-online.target"];
            Requires = [containers.ms-sonarr.ref containers.ms-radarr.ref "network-online.target"];
          };
          containerConfig = {
            image = "lscr.io/linuxserver/prowlarr:latest";
            autoUpdate = "registry";
            pod = pods.mediaserver.ref;
            environments = {
              TZ = "America/Los_Angeles";
              PUID = "633";
              PGID = "633";
            };
            volumes = [
              "/srv/containers/mediaserver/config/prowlarr:/config:Z"
            ];
          };
        };
        ms-bazarr = {
          unitConfig = {
            After = [containers.ms-sonarr.ref containers.ms-radarr.ref "network-online.target"];
            Requires = [containers.ms-sonarr.ref containers.ms-radarr.ref "network-online.target"];
          };
          containerConfig = {
            image = "lscr.io/linuxserver/bazarr:latest";
            autoUpdate = "registry";
            pod = pods.mediaserver.ref;
            environments = {
              TZ = "America/Los_Angeles";
              PUID = "633";
              PGID = "633";
            };
            volumes = [
              "/srv/containers/mediaserver/config/bazarr:/config:Z"
              "/mnt/data/mediaserver:/data:z"
            ];
          };
        };
      };
    };
  };
}
