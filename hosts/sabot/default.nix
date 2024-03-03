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

  security = {
    sudo.extraConfig = ''
      Defaults lecture = never
    '';
  };

  programs = {
    hyprland = {
      enable = true;
      xwayland.enable = true;
    };
  };

  services.openssh.enable = true;

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
      substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
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
