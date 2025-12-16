{
  config,
  lib,
  ...
}: {
  flakeMods.impermanence.extraDirs = [
    "/etc/crowdsec"
  ];

  systemd.services.crowdsec-firewall-bouncer.serviceConfig.AmbientCapabilities = lib.mkAfter [
    "CAP_NET_RAW"
  ];

  systemd.tmpfiles.rules = [
    # See https://github.com/NixOS/nixpkgs/issues/445342
    "d /etc/crowdsec 0750 crowdsec crowdsec - -"
    "d /var/lib/crowdsec 0750 crowdsec crowdsec - -"
    # In contrast to the `lapi.credentialsFile`, the `capi.credentialsFile` must already exist beforehand
    "f /etc/crowdsec/online_api_credentials.yaml 0750 crowdsec crowdsec - -"
  ];

  services = {
    crowdsec = {
      enable = true;
      hub = {
        collections = [
          "crowdsecurity/linux"
          "crowdsecurity/caddy"
          "LePresidente/gitea"
        ];
      };
      settings = {
        general.api.server.enable = true;

        lapi.credentialsFile = "/etc/crowdsec/local_api_credentials.yaml";
        capi.credentialsFile = "/etc/crowdsec/online_api_credentials.yaml";
      };
      localConfig.acquisitions = [
        # SSH
        {
          journalctl_filter = [
            "_SYSTEMD_UNIT=sshd.service"
          ];
          labels = {
            type = "syslog";
          };
          source = "journalctl";
        }

        # Caddy
        {
          filenames = [
            "/var/log/caddy/*.log"
          ];
          labels = {
            type = "caddy";
          };
        }
        # Container Logs
        # These can be ingested with journalctl due to podman quadlets.
        # Forgejo
        {
          journalctl_filter = [
            "_UID=1000 _SYSTEMD_USER_UNIT=git-forgejo.service"
          ];
          labels = {
            type = "gitea";
          };
          source = "journalctl";
        }
      ];
    };
    crowdsec-firewall-bouncer = {
      enable = true;
      registerBouncer = {
        enable = true;
        bouncerName = "canister-firewall";
      };
    };
  };
}
