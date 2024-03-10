{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.impermanence.nixosModules.impermanence
    ./hardware-configuration.nix
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  time.timeZone = "America/Los_Angeles";

  environment.persistence."/nix/persist" = {
    directories = [
      "/etc/nixos" # nixos system config files
      "/var/lib" # system service persistent data
      "/var/log" # the place that journald dumps logs to
    ];
    files = [
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/machine-id"
    ];
  };

  environment.systemPackages = with pkgs; [
    gvfs
  ];

  networking.networkmanager.enable = true;

  security = {
    sudo.extraConfig = ''
      Defaults lecture = never
    '';
  };

  programs = {
    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-volman
        thunar-archive-plugin
        thunar-media-tags-plugin
      ];
    };
  };

  services = {
    openssh.enable = true;
    pipewire = {
      enable = true;
      wireplumber.enable = true;
    };
  };

  # xdg.portal = {
  #   enable = true;
  #   extraPortals = with pkgs; [
  #     xdg-desktop-portal-gtk
  #   ];
  # };

  users.mutableUsers = false;

  # documentation.nixos.enable = false;

  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = ["nix-command" "flakes"];
    };
    # gc = {
    #   automatic = true;
    #   dates = "weekly";
    #   options = "--delete-older-than 30d";
    # };
  };

  system = {
    # autoUpgrade = {
    #   enable = true;
    #   allowReboot = true;
    #   dates = "03:00";
    #   flake = "github:InaccurateTank/nixos-configs";
    # };
    stateVersion = "23.11";
  };
}
