{ inputs, config, lib, pkgs, ... }:

let
  fetchKeys = username:(builtins.fetchurl {
    url = "https://github.com/${username}.keys";
    sha256 = "sha256:0c0b3c3kx3z7hlc5bl1bl30mvc3z9afpmsrikzq49wgl7zpnjpyy";
  });
in {
  imports = [
    inputs.pterodactyl.nixosModules.pterodactyl-wings
    ../../modules/security.nix
    ./hardware-configuration.nix
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  time.timeZone = "America/Los_Angeles";

  networking = {
    hostName = "nixtest";
    interfaces = {
      ens18.ipv4.addresses = [{
        address = "10.10.5.24";
        prefixLength = 24;
      }];
    };
    defaultGateway = "10.10.5.1";
    nameservers = [ "10.10.5.1" ];
  };

  environment.systemPackages = with pkgs; [
    git
  ];

  services = {
    openssh.enable = true;
    qemuGuest.enable = true;
    # pterodactyl = {
    #   wings = {
    #     enable = true;
    #     configuration = "test";
    #   };
    # };
  };

  users.users.control = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keyFiles = [ (fetchKeys "inaccuratetank") ];
  };

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
