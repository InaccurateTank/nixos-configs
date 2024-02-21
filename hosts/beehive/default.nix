{ impermanence, pterodactyl, crowdsec, ... }:
{ config, lib, pkgs, ... }:

{
  imports = [
    impermanence.nixosModules.impermanence
    pterodactyl.nixosModules.pterodactyl-wings
    crowdsec.nixosModules.crowdsec
    ../../modules/security.nix
    ./hardware-configuration.nix
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  time.timeZone = "America/Los_Angeles";

  networking = {
    hostName = "beehive";
    interfaces = {
      ens18.ipv4.addresses = [{
        address = "10.10.5.24";
        prefixLength = 24;
      }];
    };
    defaultGateway = "10.10.5.1";
    nameservers = [ "10.10.5.1" ];
  };

  environment.persistence."/nix/persist" = {
    directories = [
      "/etc/nixos" # nixos system config files
      "/etc/crowdsec"
      "/srv"       # service data
      "/var/lib"   # system service persistent data
      "/var/log"   # the place that journald dumps logs to
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

  environment.systemPackages = with pkgs; [
    git
  ];

  services = {
    openssh.enable = true;
    qemuGuest.enable = true;
    crowdsec.enable = true;
    cs-firewall-bouncer.enable = true;
    caddy = {
      enable = true;
      package = (pkgs.callPackage ../../pkgs/custom-caddy.nix {
        externalPlugins = [
          { name = "porkbun"; repo = "github.com/caddy-dns/porkbun"; version = "v0.1.4"; }
        ];
        vendorHash = "sha256-tR9DQYmI7dGvj0W0Dsze0/BaLjG84hecm0TPiCVSY2Y=";
      });
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

  nix = {
    settings.experimental-features = [ "nix-command" "flakes" ];
    settings.auto-optimise-store = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  system = {
    autoUpgrade = {
      enable = true;
      allowReboot = true;
      dates = "03:00";
      flake = "github:InaccurateTank/nixos-configs";
    };
    stateVersion = "23.11";
  };
}