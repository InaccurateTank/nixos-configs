{
  config,
  lib,
  ...
}: {
  # Temporary until https://github.com/NixOS/nixpkgs/pull/459188
  systemd.services.crowdsec-firewall-bouncer.serviceConfig.AmbientCapabilities = lib.mkAfter [
    "CAP_NET_RAW"
  ];
  systemd.services.crowdsec-firewall-bouncer.serviceConfig.CapabilityBoundingSet = lib.mkAfter [
    "CAP_NET_RAW"
  ];

  systemd.tmpfiles.rules = [
    # See https://github.com/NixOS/nixpkgs/issues/445342
    "d /var/lib/crowdsec 0750 crowdsec crowdsec - -"
    # Stuff is created here, should make it manually.
    "d /etc/crowdsec 0750 crowdsec crowdsec - -"
    # In contrast to the `lapi.credentialsFile`, the `capi.credentialsFile` must already exist beforehand
    "f /var/lib/crowdsec/online_api_credentials.yaml 0750 crowdsec crowdsec - -"
  ];

  services = {
    crowdsec = {
      enable = true;
      hub = {
        collections = [
          "crowdsecurity/linux"
          "crowdsecurity/caddy"
        ];
      };
      settings = {
        general.api.server.enable = true;

        lapi.credentialsFile = "/var/lib/crowdsec/local_api_credentials.yaml";
        capi.credentialsFile = "/var/lib/crowdsec/online_api_credentials.yaml";
      };
      localConfig = {
        acquisitions = [
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
              "_SYSTEMD_USER_UNIT=git-forgejo.service"
            ];
            labels = {
              type = "syslog";
            };
            source = "journalctl";
          }
        ];
        parsers.s01Parse = import ./forgejo-logs.nix;
        scenarios = import ./forgejo-bf.nix;
      };
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
