{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) types;
  inherit (lib) mkOption mkEnableOption mkPackageOption;
  inherit (lib.lists) optional;
  inherit (lib.modules) mkIf;

  cfg = config.flakeMods.pelican.panel;
  pelican-panel = cfg.package.override { inherit (cfg) dataDir runtimeDir; };
  user = cfg.user;
  group = cfg.group;

  pelican-panel-artisan = pkgs.writeShellScriptBin "pelican-panel-artisan" ''
    cd ${pelican-panel}
    sudo=exec
    if [[ "$USER" != ${user} ]]; then
      sudo='exec /run/wrappers/bin/sudo -u ${user}'
    fi
    $sudo ${cfg.phpPackage}/bin/php artisan "$@"
  '';

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
in {
  options.flakeMods.pelican.panel = {
    enable = mkEnableOption "Pelican Panel service";
    package = mkPackageOption pkgs.flakePkgs "pelican-panel" { };
    phpPackage = mkPackageOption pkgs.flakePkgs "pelican-php" { };

    user = lib.mkOption {
      description = "The user Pelican Panel should run as.";
      type = lib.types.str;
      default = "pelican-panel";
    };

    group = lib.mkOption {
      description = "The group Pelican Panel should run as.";
      type = lib.types.str;
      default = "pelican-panel";
    };

    dataDir = mkOption {
      description = "State directory of the panel.";
      type = types.path;
      default = "/var/lib/pelican/panel";
    };

    runtimeDir = mkOption {
      description = "Path of where to serve the panel from.";
      type = types.path;
      default = "/run/pelican-panel";
    };

    maxFilesize = mkOption {
      description = "Maximum size of files in the panel.";
      type = types.int;
      default = 2;
    };
  };

  config = mkIf cfg.enable {
    users.users.pelican-panel = mkIf (user == "pelican-panel") {
      inherit group;
      isSystemUser = true;
    };
    users.groups.pelican-panel = mkIf (group == "pelican-panel") { };

    environment.systemPackages = [pelican-panel-artisan];

    services.phpfpm.pools.pelican-panel = {
      inherit (cfg) user group phpPackage;
      settings = {
        "listen.owner" = user;
        "listen.group" = group;
        "listen.mode" = "0660";
        "catch_workers_output" = "yes";

        "pm" = "dynamic";
        "pm.max_children" = 32;
        "pm.max_requests" = 500;
        "pm.start_servers" = 2;
        "pm.min_spare_servers" = 2;
        "pm.max_spare_servers" = 5;
      };
    };

    systemd = {
      tmpfiles.rules = [
        "d ${cfg.runtimeDir}/        0755 ${user} ${group} - -"
        "d ${cfg.runtimeDir}/cache   0755 ${user} ${group} - -"
      ];

      services = {
        phpfpm-pelican-panel.after = [ "pelican-panel-deploy.service" ];

        pelican-panel-deploy = {
          description = "Pelican panel setup, migrations and updating.";
          after = [ "network.target" ];
          wantedBy = [ "multi-user.target" ];
          path = with pkgs; [
            bash
            rsync
            pelican-panel-artisan
          ];
          script = ''
            # Before running any PHP program, cleanup the code cache.
            # It's necessary if you upgrade the application otherwise you might
            # try to import non-existent modules.
            rm -f ${cfg.runtimeDir}/app.php
            rm -f ${cfg.runtimeDir}/providers.php
            rm -rf ${cfg.runtimeDir}/cache/*

            # Copy env example if no env file
            [[ ! -f ${cfg.dataDir}/.env ]] && echo "Copying example env" && cp ${pelican-panel}/.env.example ${cfg.dataDir}/.env && chmod 640 ${cfg.dataDir}/.env

            # Link the static storage (package provided) to the runtime storage
            echo "Linking storage"
            mkdir -p ${cfg.dataDir}/storage/{avatars,fonts}
            rsync -av --no-perms ${pelican-panel}/storage-static/ ${cfg.dataDir}/storage

            # Files shouldn't have execute
            chmod -R 755 ${cfg.dataDir}/storage
            find ${cfg.dataDir}/storage -type f -exec chmod 644 {} +

            # Link the app.php and providers.php in the runtime folder.
            # We cannot link the cache folder only because bootstrap folder needs to be writeable.
            echo "Linking runtime"
            ln -sf ${pelican-panel}/bootstrap-static/app.php ${cfg.runtimeDir}/app.php
            ln -sf ${pelican-panel}/bootstrap-static/providers.php ${cfg.runtimeDir}/providers.php

            # https://laravel.com/docs/10.x/filesystem#the-public-disk
            # Creating the public/storage → storage/app/public link
            # is unnecessary as it's part of the installPhase.

            # Generate key if it doesn't exist
            [[ ! -f ${cfg.dataDir}/.key-generated ]] && echo "Generating key" && pelican-panel-artisan key:generate --force && touch ${cfg.dataDir}/.key-generated

            echo "Optimizing"
            pelican-panel-artisan optimize:clear
            pelican-panel-artisan filament:optimize

            # Link the static database (package provided) to the runtime database
            echo "Database tasks"
            mkdir -p ${cfg.dataDir}/database
            rsync -av --no-perms ${pelican-panel}/database-static/ ${cfg.dataDir}/database
            [[ -f ${cfg.dataDir}/database/database.sqlite ]] && pelican-panel-artisan migrate --seed --force
            echo "Done"
          '';
          serviceConfig = {
            Type = "oneshot";
            User = user;
            Group = group;
            StateDirectory = lib.mkIf (cfg.dataDir == "/var/lib/pelican/panel") "pelican/panel";
            UMask = "077";
          };
        };

        pelican-queue = {
          description = "Pelican queue worker";
          after = [
            "network.target"
            config.systemd.services.pelican-panel-deploy.name
          ];
          requires = [ config.systemd.services.pelican-panel-deploy.name ];
          wantedBy = [ "multi-user.target" ];
          serviceConfig = {
            Type = "simple";
            User = user;
            Group = group;
            Restart = "always";
            StateDirectory = lib.mkIf (cfg.dataDir == "/var/lib/pelican/panel") "pelican/panel";
            ExecStart = "${pelican-panel-artisan}/bin/pelican-panel-artisan queue:work --tries=3";
            RestartSec = 5;
          };
          unitConfig = {
            StartLimitIntervalSec = 180;
            StartLimitBurst = 30;
          };
        };

        pelican-cron = {
          description = "Pelican periodic tasks";
          serviceConfig = {
            Type = "simple";
            User = user;
            Group = group;
            StateDirectory = lib.mkIf (cfg.dataDir == "/var/lib/pelican/panel") "pelican/panel";
            ExecStart = "${pelican-panel-artisan}/bin/pelican-panel-artisan schedule:run";
          };
          wantedBy = [ "multi-user.target" ];
        };
      };

      timers = {
        pelican-cron = {
          description = "Pelican periodic tasks timer";
          after = [ config.systemd.services.pelican-panel-deploy.name ];
          requires = [ "phpfpm-pelican-panel.service" ];
          wantedBy = [ "timers.target" ];
          timerConfig = {
            OnBootSec = "1m";
            OnUnitActiveSec = "1m";
          };
        };
      };
    };

    # Caddy
    users.users."${config.services.caddy.user}".extraGroups = [ group ];
    services.caddy = {
      enable = lib.mkDefault true;
      globalConfig = ''
        servers :80 {
          timeouts {
            read_body 120s
          }
        }
      '';
      virtualHosts.":80".extraConfig = ''
        root * ${pelican-panel}/public

        file_server

        php_fastcgi unix/${config.services.phpfpm.pools.pelican-panel.socket} {
            root ${pelican-panel}/public
            index index.php

            env PHP_VALUE "upload_max_filesize = 100M
            post_max_size = 100M"
            env HTTP_PROXY ""

            read_timeout 300s
            dial_timeout 300s
            write_timeout 300s
        }

        header Strict-Transport-Security "max-age=16768000; preload;"
        header X-Content-Type-Options "nosniff"
        header X-XSS-Protection "1; mode=block;"
        header X-Robots-Tag "none"
        header Content-Security-Policy "frame-ancestors 'self'"
        header X-Frame-Options "DENY"
        header Referrer-Policy "same-origin"

        request_body {
            max_size 100m
        }

        respond /.ht* 403

        log {
            output file /var/log/caddy/pelican.log {
                roll_size 100MiB
                roll_keep_for 7d
            }
            level INFO
        }
      '';
    };
  };
}
