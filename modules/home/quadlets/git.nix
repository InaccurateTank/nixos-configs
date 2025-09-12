{
  config,
  lib,
  ...
}: let
  cfg = config.flakeMods.quadlets.git;
in {
  options.flakeMods.quadlets.git = {
    enable = lib.mkEnableOption "forgejo git pod";

    environmentFile = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "The secrets file used by the pod for container setup. The file must contain the values for `FORGEJO__database__USER`, `FORGEJO__database__PASSWD`, `POSTGRES_USER` and `POSTGRES_PASSWORD`.";
    };

    dbName = lib.mkOption {
      type = lib.types.str;
      default = "gitrepos";
      description = "The name of the database for forgejo.";
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.quadlet = let
      inherit (config.virtualisation.quadlet) containers pods;
    in {
      pods.git = {
        autoStart = true;
        podConfig = {
          publishPorts = [
            "127.0.0.1:3000:3000/tcp" # Forgejo
            # "127.0.0.1:8923:8923/tcp" # Anubis instance
            "127.0.0.1:2222:2222/tcp" # Forgejo SSH
          ];
        };
      };
      containers = {
        git-forgejo = {
          containerConfig = {
            image = "codeberg.org/forgejo/forgejo:11-rootless";
            autoUpdate = "registry";
            pod = pods.git.ref;
            user = "1000:1000";
            environments = {
              USER_UID = "1000";
              USER_GID = "1000";
              FORGEJO__database__DB_TYPE = "postgres";
              FORGEJO__database__HOST = "127.0.0.1:5432";
              FORGEJO__database__NAME = cfg.dbName;
            };
            environmentFiles = lib.singleton cfg.environmentFile;
            volumes = [
              "/srv/containers/git/data/forgejo:/var/lib/gitea:Z"
              "/srv/containers/git/config/forgejo:/etc/gitea:Z"
            ];
          };
        };
        git-db = {
          containerConfig = {
            image = "docker.io/postgres:16";
            autoUpdate = "registry";
            pod = pods.git.ref;
            environments = {
              POSTGRES_DB = cfg.dbName;
            };
            environmentFiles = lib.singleton cfg.environmentFile;
            volumes = [
              "/srv/containers/git/data/postgres:/var/lib/postgresql/data"
            ];
          };
        };
        git-redis = {
          containerConfig = {
            image = "docker.io/valkey/valkey:8";
            autoUpdate = "registry";
            pod = pods.git.ref;
          };
        };
        # git-anubis = {
        #   containerConfig = {
        #     image = "ghcr.io/techarohq/anubis:latest";
        #     autoUpdate = "registry";
        #     pod = pods.git.ref;
        #     environments = {
        #       TARGET = "http://127.0.0.1:3000"; # Forgejo
        #     };
        #   };
        # };
      };
    };
  };
}
