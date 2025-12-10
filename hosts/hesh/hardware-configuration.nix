{
  lib,
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
    device = "/dev/disk/by-uuid/2cb76bfe-d654-4c63-8ad8-54e83a46a2a4";
    fsType = "ext4";
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/76360185-526c-4026-b88f-b0bef469eed6";
    fsType = "ext4";
  };

  fileSystems."/persist" = {
    device = "/dev/disk/by-uuid/4e507aad-4748-45b9-9489-0aded4c873e8";
    neededForBoot = true;
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/4225-1DCF";
    fsType = "vfat";
    options = ["fmask=0077" "dmask=0077"];
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/a222a611-7d30-4852-a001-026ff21ef2d6";}
  ];

  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.ens18.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
