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
  boot.initrd.kernelModules = [];
  boot.kernelModules = [];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "none";
    fsType = "tmpfs";
    options = ["defaults" "size=2G" "mode=755"];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/0D66-F75A";
    fsType = "vfat";
    options = ["defaults" "umask=0077"];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/c1ebcb8e-71f7-43ac-afec-df09b3606064";
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
    {device = "/dev/disk/by-uuid/27e3647a-62d7-4481-9ecb-3e35703569f1";}
  ];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
