{
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.flakeMods.btrfs-persist;
in {
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];

  options.flakeMods.btrfs-persist.enable = lib.mkEnableOption "flake Hyprland preset";

  config = lib.mkIf cfg.enable {
    boot.initrd = {
      postDeviceCommands = lib.mkBefore ''
        mkdir -p /mnt
        mount -o subvol=/ /dev/disk/by-label/${hostname} /mnt

        echo "Cleaning subvolume"
        btrfs subvolume list -o /mnt/root | cut -f9 -d ' ' |
        while read subvolume; do
          btrfs subvolume delete "/mnt/$subvolume"
        done && btrfs subvolume delete /mnt/root

        echo "Restoring blank subvolume"
        btrfs subvolume snapshot /mnt/root-blank /mnt/root

        umount /mnt
      '';
      supportedFilesystems = [ "btrfs" ];
    };

    # Bare minimum impermenance
    environment.persistence."/persist" = {
      hideMounts = true;

      directories = [
        "/etc/nixos" # nixos system config files
        "/var/lib" # system service persistent data
        "/var/log" # the place that journald dumps logs to
      ]
      ++ lib.optionals config.flakeMods.secrets.enable [{
          # Secrets repo ssh
          directory = "/root/.ssh";
          mode = "0700";
      }];

      files = [
        "/etc/machine-id"
      ]
      ++ lib.optionals config.services.openssh.enable [
        "/etc/ssh/ssh_host_rsa_key"
        "/etc/ssh/ssh_host_rsa_key.pub"
        "/etc/ssh/ssh_host_ed25519_key"
        "/etc/ssh/ssh_host_ed25519_key.pub"
      ];
    };

    # # Standardized filesystem setup.
    # fileSystems = {
    #   "/" = {
    #     device = "/dev/disk/by-label/${hostname}";
    #     fsType = "btrfs";
    #     options = [ "subvol=root" "compress=zstd" ];
    #   };

    #   "/nix" = {
    #     device = "/dev/disk/by-label/${hostname}";
    #     fsType = "btrfs";
    #     options = [ "subvol=nix" "noatime" "compress=zstd" ];
    #   };

    #   "/persist" = {
    #     device = "/dev/disk/by-label/${hostname}";
    #     fsType = "btrfs";
    #     options = [ "subvol=persist" "compress=zstd" ];
    #     neededForBoot = true;
    #   };

    #   "/swap" = {
    #     device = "/dev/disk/by-label/${hostname}";
    #     fsType = "btrfs";
    #     options = [ "subvol=swap" "noatime" ];
    #   };
    # };

    # swapDevices = [{
    #   device = "/swap/swapfile";
    #   size = 4096;
    # }];
  };
}
