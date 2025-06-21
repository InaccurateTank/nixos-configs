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

  boot.initrd.availableKernelModules = ["uhci_hcd" "ehci_pci" "ahci" "virtio_pci" "virtio_scsi" "sd_mod" "sr_mod"];
  boot.initrd.kernelModules = ["dm-snapshot"];
  boot.kernelModules = [];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "tmpfs";
    fsType = "tmpfs";
    options = ["defaults" "size=25%" "mode=755"];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/ec8a414c-a8a9-4247-af9c-541f68b8e35d";
    fsType = "ext4";
  };

  fileSystems."/persist" = {
    device = "/dev/disk/by-uuid/148bae3a-07a1-4b17-b0b1-c14e72b028ec";
    fsType = "ext4";
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/e92a803a-293b-4573-b320-e1b9b761d31e";
    fsType = "ext4";
  };

  fileSystems."/mnt/data" = {
    device = "/dev/disk/by-uuid/8edf7828-1ab7-455d-887e-7b61aabbaa77";
    fsType = "xfs";
  };

  fileSystems."/srv/containers" = {
    device = "/dev/disk/by-uuid/4a7fdfc7-497b-456f-9c73-066a57b6c71f";
    fsType = "xfs";
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/be948b47-cfb7-4b4e-8086-097bd105796d";}
  ];

  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.ens18.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
