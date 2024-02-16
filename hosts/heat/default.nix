{ config, lib, pkgs, ... }:

{
  wsl.enable = true;
  wsl.defaultUser = "inaccuratetank";

  networking.hostName = "heat";

  environment.systemPackages = with pkgs; [
    git
  ];

  users.mutableUsers = false;
  users.users.inaccuratetank = {
    isNormalUser = true;
  };

  system.stateVersion = "23.11";
}
