{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.impermanence.nixosModules.impermanence
    inputs.pterodactyl.nixosModules.pterodactyl-wings
    inputs.crowdsec.nixosModules.crowdsec
    ./hardware-configuration.nix
  ];

  flakeMods = {
    vscode-remote-fix.enable = true;
    secrets = {
      enable = true;
      useSshKey = true;
    };
  };

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  time.timeZone = "America/Los_Angeles";

  networking = {
    interfaces = {
      ens18.ipv4.addresses = [
        {
          address = "10.10.5.24";
          prefixLength = 24;
        }
      ];
    };
    defaultGateway = "10.10.5.1";
    nameservers = ["10.10.5.1"];
  };

  environment.persistence."/nix/persist" = {
    directories = [
      "/etc/nixos" # nixos system config files
      "/etc/crowdsec"
      "/etc/sops"
      "/srv" # service data
      "/var/lib" # system service persistent data
      "/var/log" # the place that journald dumps logs to
      {
        # Secret repo ssh
        directory = "/root/.ssh";
        mode = "0700";
      }
    ];
    files = [
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/machine-id"
    ];
  };

  security.sudo.extraConfig = ''
    Defaults lecture = never
  '';

  services = {
    openssh.enable = true;
    qemuGuest.enable = true;
    crowdsec.enable = true;
    cs-firewall-bouncer.enable = true;
    caddy = {
      enable = true;
      package = pkgs.flakePkgs.custom-caddy;
    };
    # pterodactyl = {
    #   wings = {
    #     enable = true;
    #     configuration = "test";
    #   };
    # };
  };

  programs.zsh.enable = true;

  users.mutableUsers = false;
  users.defaultUserShell = pkgs.zsh;

  system = {
    stateVersion = "23.11";
  };
}
