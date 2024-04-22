{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod"];
  boot.initrd.kernelModules = ["amdgpu"];
  boot.kernelModules = [];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/1abfef81-4de2-409f-b0c9-180fc71fe4c3";
    fsType = "btrfs";
    options = ["subvol=@root" "compress=zstd"];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/7100-EF19";
    fsType = "vfat";
    options = ["defaults" "umask=0077"];
  };

  fileSystems."/persist" = {
    device = "/dev/disk/by-uuid/1abfef81-4de2-409f-b0c9-180fc71fe4c3";
    fsType = "btrfs";
    options = ["subvol=@persist" "compress=zstd"];
    neededForBoot = true;
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/1abfef81-4de2-409f-b0c9-180fc71fe4c3";
    fsType = "btrfs";
    options = ["subvol=@nix" "noatime" "compress=zstd"];
  };

  fileSystems."/swap" = {
    device = "/dev/disk/by-uuid/1abfef81-4de2-409f-b0c9-180fc71fe4c3";
    fsType = "btrfs";
    options = ["subvol=@swap" "noatime"];
  };

  swapDevices = [
    {
      device = "/swap/swapfile";
      size = 4096;
    }
  ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp8s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
