{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  boot.initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "virtio_pci" "virtio_scsi" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = { device = "none";
    fsType = "tmpfs";
    options = [ "defaults" "size=2G" "mode=755" ];
  };

  fileSystems."/boot" = { device = "/dev/disk/by-uuid/1300-C978";
    fsType = "vfat";
    options = [ "umask=0077" ];
  };

  fileSystems."/nix" = { device = "/dev/disk/by-uuid/38775e9a-e274-4da7-9966-641f7f11f092";
    fsType = "ext4";
  };

  fileSystems."/etc/nixos" = { device = "/nix/persist/etc/nixos";
    fsType = "none";
    options = [ "bind" ];
  };

  fileSystems."/var/log" = { device = "/nix/persist/var/log";
    fsType = "none";
    options = [ "bind" ];
  };

  swapDevices = [ ];

  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.ens18.useDHCP = lib.mkDefault true;
  # networking.interfaces.ens19.useDHCP = lib.mkDefault true;
  # networking.interfaces.ens20.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
