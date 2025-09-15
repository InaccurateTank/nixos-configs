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

    # protocol = lib.mkOption {
    #   type = lib.types.str;
    #   default = "http";
    #   description = "The protocol used for access to the instance.";
    # };

    # domain = lib.mkOption {
    #   type = lib.types.str;
    #   default = "127.0.0.1:3000";
    #   description = "The FQDN of the instance.";
    # };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.quadlet = let
      inherit (config.virtualisation.quadlet) containers pods;
    in {
      autoEscape = lib.mkDefault true;
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
              # FORGEJO__server__ROOT_URL = "${cfg.protocol}://${cfg.domain}";
              # FORGEJO__server__SSH_DOMAIN = "${cfg.domain}";
              FORGEJO__cache__ADAPTER = "twoqueue";
              FORGEJO__cache__HOST = "{"size":100, "recent_ratio":0.25, "ghost_ratio":0.5}";
            };
            environmentFiles = lib.singleton cfg.environmentFile;
            volumes = [
              "/srv/containers/git/data/forgejo:/var/lib/gitea:Z"
              # "/srv/containers/git/config/forgejo:/etc/gitea:Z"
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
        # git-redis = {
        #   containerConfig = {
        #     image = "docker.io/valkey/valkey:8";
        #     autoUpdate = "registry";
        #     pod = pods.git.ref;
        #   };
        # };
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
