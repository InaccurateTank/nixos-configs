{
  config,
  pkgs,
  lib,
  ...
}: {
  # systemd.tmpfiles.rules = [
  #   # See https://github.com/NixOS/nixpkgs/issues/445342
  #   "d /var/lib/crowdsec 0750 crowdsec crowdsec - -"
  #   # Stuff is created here, should make it manually.
  #   # "d /etc/crowdsec 0750 crowdsec crowdsec - -"
  #   # In contrast to the `lapi.credentialsFile`, the `capi.credentialsFile` must already exist beforehand
  #   "f /var/lib/crowdsec/online_api_credentials.yaml 0750 crowdsec crowdsec - -"
  # ];

  # Patch for dynamicuser issues
  # systemd.services = {
  #   crowdsec-update-hub.serviceConfig.DynamicUser = lib.mkForce false;
  #   crowdsec.serviceConfig.DynamicUser = lib.mkForce false;
  #   crowdsec-firewall-bouncer-register = let
  #       apiKeyFile = "/var/lib/crowdsec-firewall-bouncer-register/api-key.cred";
  #     in
  #   {
  #     serviceConfig.DynamicUser = lib.mkForce false;
  #     path = [ config.services.crowdsec.package ];
  #     script = lib.mkForce ''
  #       cscli=/run/current-system/sw/bin/cscli
  #       if $cscli bouncers list --output json | ${lib.getExe pkgs.jq} -e -- ${lib.escapeShellArg "any(.[]; .name == \"${config.services.crowdsec-firewall-bouncer.registerBouncer.bouncerName}\")"} >/dev/null; then
  #         # Bouncer already registered. Verify the API key is still present
  #         if [ ! -f ${apiKeyFile} ]; then
  #           echo "Bouncer registered but API key is not present"
  #           exit 1
  #         fi
  #       else
  #         # Bouncer not registered
  #         # Remove any previously saved API key
  #         rm -f '${apiKeyFile}'
  #         # Register the bouncer and save the new API key
  #         if ! $cscli bouncers add --output raw -- ${lib.escapeShellArg config.services.crowdsec-firewall-bouncer.registerBouncer.bouncerName} >${apiKeyFile}; then
  #           # Failed to register the bouncer
  #           rm ${apiKeyFile}
  #           exit 1
  #         fi
  #       fi
  #     '';
  #   };
  #   crowdsec-firewall-bouncer.serviceConfig.DynamicUser = lib.mkForce false;
  # };

  services = {
    crowdsec = {
      enable = true;
      autoUpdateService = true;
      hub = {
        collections = [
          "crowdsecurity/linux"
          "crowdsecurity/caddy"
        ];
      };
      settings = {
        # config.api.server.enable = true;
        # config.api.client.credentials_path = "/var/lib/crowdsec/local_api_credentials.yaml";
        # config.api.server.online_client.credentials_path = "/var/lib/crowdsec/online_api_credentials.yaml";
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
      # localConfig = {
      #   acquisitions = [
      #     # SSH
      #     {
      #       journalctl_filter = [
      #         "_SYSTEMD_UNIT=sshd.service"
      #       ];
      #       labels = {
      #         type = "syslog";
      #       };
      #       source = "journalctl";
      #     }
      #     # Caddy
      #     {
      #       filenames = [
      #         "/var/log/caddy/*.log"
      #       ];
      #       labels = {
      #         type = "caddy";
      #       };
      #     }
      #     # Container Logs
      #     # These can be ingested with journalctl due to podman quadlets.
      #     # Forgejo
      #     {
      #       journalctl_filter = [
      #         "_SYSTEMD_USER_UNIT=git-forgejo.service"
      #       ];
      #       labels = {
      #         type = "syslog";
      #       };
      #       source = "journalctl";
      #     }
      #   ];
      #   parsers.s01Parse = import ./forgejo-logs.nix;
      #   scenarios = import ./forgejo-bf.nix;
      # };
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
