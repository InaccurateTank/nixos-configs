{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  boot.initrd.availableKernelModules = ["ata_piix" "uhci_hcd" "virtio_pci" "virtio_scsi" "sd_mod" "sr_mod"];
  boot.initrd.kernelModules = ["dm-snapshot"];
  boot.kernelModules = [];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "none";
    fsType = "tmpfs";
    options = ["defaults" "size=2G" "mode=755"];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/11E8-04F3";
    fsType = "vfat";
    options = ["defaults" "umask=0077"];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/127407c8-c8cf-4a6f-9f58-e4f21722cce5";
    fsType = "ext4";
    options = ["defaults"];
  };

  fileSystems."/etc/nixos" = {
    device = "/nix/persist/etc/nixos";
    fsType = "none";
    options = ["bind"];
  };

  fileSystems."/var/log" = {
    device = "/nix/persist/var/log";
    fsType = "none";
    options = ["bind"];
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/c1fae44a-65e0-4ed0-b521-1ca7d1029fc3";}
  ];

  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.ens18.useDHCP = lib.mkDefault true;
  # networking.interfaces.ens19.useDHCP = lib.mkDefault true;
  # networking.interfaces.ens20.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
