{ nixos-wsl, ... }:
{ config, lib, pkgs, ... }:

{
  imports = [
    nixos-wsl.nixosModules.wsl
  ];

  wsl.enable = true;
  wsl.defaultUser = "inaccuratetank";

  networking.hostName = "heat";

  security.sudo.wheelNeedsPassword = true;

  environment.systemPackages = with pkgs; [
    git
  ];

  users.users.inaccuratetank = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "23.11";
}
