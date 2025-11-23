{
  pkgs,
  inputs,
  config,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    inputs.quadlet-nix.nixosModules.quadlet
  ];

  flakeMods = {
    auto-upgrade = {
      enable = true;
      reboot = true;
      # The VMs are relatively small...
      maxJobs = 1;
    };
    impermanence.enable = true;
    secrets = {
      enable = true;
      useSshKey = true;
    };
    # Nerd fonts make things weird on the host, but 99% of the time we're interacting via ssh anyway.
    shell-prompt.enable = true;
    vscode-remote-fix.enable = true;
  };

  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
  };

  time.timeZone = "America/Los_Angeles";

  security.sudo.extraConfig = ''
    Defaults lecture = never
  '';

  sops.secrets."caddyEnv" = {
    format = "dotenv";
    sopsFile = "${inputs.secrets}/canister/caddy.env";
  };

  virtualisation.quadlet.enable = true;

  networking.firewall.allowedTCPPorts = [
    80
    443
    51413
  ];

  services = {
    openssh.enable = true;
    qemuGuest.enable = true;
    # Caddy on the host to do the routing.
    caddy = {
      enable = true;
      package = pkgs.flakePkgs.custom-caddy;
      globalConfig = ''
        acme_dns porkbun {
          api_key {env.PORKBUN_API_KEY}
          api_secret_key {env.PORKBUN_API_SECRET_KEY}
        }
      '';
      environmentFile = config.sops.secrets."caddyEnv".path;
      virtualHosts = {
        "git.inaccuratetank.gay".extraConfig = ''
          reverse_proxy 127.0.0.1:3000 {
            header_up X-Real-Ip {remote_host}
          }
        '';

        "media.inaccuratetank.gay".extraConfig = ''
          reverse_proxy 127.0.0.1:8096
        '';

        "*.inaccuratetank.gay".extraConfig = ''
          @local_only {
            remote_ip 192.168.0.0/16 172.16.0.0/12 10.0.0.0/8 127.0.0.1/8
          }
          handle @local_only {
            @sonarr host sonarr.inaccuratetank.gay
            handle @sonarr {
              reverse_proxy 127.0.0.1:8989
            }

            @radarr host radarr.inaccuratetank.gay
            handle @radarr {
              reverse_proxy 127.0.0.1:7878
            }

            @prowlarr host prowlarr.inaccuratetank.gay
            handle @prowlarr {
              reverse_proxy 127.0.0.1:9696
            }

            @flaresolverr host flaresolverr.inaccuratetank.gay
            handle @flaresolverr {
              reverse_proxy 127.0.0.1:8191
            }

            @bazarr host bazarr.inaccuratetank.gay
            handle @bazarr {
              reverse_proxy 127.0.0.1:6767
            }

            @transmission host transmission.inaccuratetank.gay
            handle @transmission {
              reverse_proxy 127.0.0.1:9091
            }
          }
          abort
        '';
      };
    };
  };

  programs.zsh.enable = true;

  users = {
    mutableUsers = false;
    defaultUserShell = pkgs.zsh;
  };

  system = {
    stateVersion = "25.05";
  };
}
