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
            # "127.0.0.1:8096:8096/tcp" # Jellyfin HTTP
            "127.0.0.1:8096:8923/tcp" # Anubis instance
            "127.0.0.1:8989:8989/tcp" # Sonarr
            "127.0.0.1:7878:7878/tcp" # Radarr
            # "127.0.0.1:5690:5690/tcp" Wizarr
            # "127.0.0.1:5055:5055/tcp" Jellyseer
            "127.0.0.1:9696:9696/tcp" # Prowlarr
            "127.0.0.1:8191:8191/tcp" # Flaresolverr
            "127.0.0.1:6767:6767/tcp" # Bazarr
            "127.0.0.1:9091:9091/tcp" # Transmission Web
            "51413:51413/udp" # Transmission Connection Port
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
            After = [containers.ms-jellyfin.ref];
            Requires = [containers.ms-jellyfin.ref];
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
            After = [containers.ms-jellyfin.ref];
            Requires = [containers.ms-jellyfin.ref];
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
            After = [containers.ms-sonarr.ref containers.ms-radarr.ref];
            Requires = [containers.ms-sonarr.ref containers.ms-radarr.ref];
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
        ms-flaresolverr = {
          unitConfig = {
            After = [containers.ms-sonarr.ref containers.ms-radarr.ref];
            Requires = [containers.ms-sonarr.ref containers.ms-radarr.ref];
          };
          containerConfig = {
            image = "ghcr.io/flaresolverr/flaresolverr:latest";
            autoUpdate = "registry";
            pod = pods.mediaserver.ref;
            environments = {
              LOG_LEVEL = "info";
            };
          };
        };
        ms-bazarr = {
          unitConfig = {
            After = [containers.ms-sonarr.ref containers.ms-radarr.ref];
            Requires = [containers.ms-sonarr.ref containers.ms-radarr.ref];
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
        ms-transmission = {
          unitConfig = {
            After = [containers.ms-sonarr.ref containers.ms-radarr.ref];
            Requires = [containers.ms-sonarr.ref containers.ms-radarr.ref];
          };
          containerConfig = {
            image = "lscr.io/linuxserver/transmission:latest";
            autoUpdate = "registry";
            pod = pods.mediaserver.ref;
            environments = {
              TZ = "America/Los_Angeles";
              PUID = "633";
              PGID = "633";
              TRANSMISSION_WEB_HOME = "/config/flood-for-transmission";
            };
            volumes = [
              "/srv/containers/mediaserver/config/transmission:/config:Z"
              "/mnt/data/mediaserver/torrents:/downloads:z"
              "/srv/containers/mediaserver/watch:/watch:Z"
            ];
          };
        };
        ms-anubis = {
          containerConfig = {
            image = "ghcr.io/techarohq/anubis:latest";
            autoUpdate = "registry";
            pod = pods.git.ref;
            environments = {
              TARGET = "http://127.0.0.1:8096"; # Forgejo
            };
          };
        };
      };
    };
  };
}
