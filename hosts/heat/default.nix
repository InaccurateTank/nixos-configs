{ config, lib, pkgs, ... }:

{
  wsl.enable = true;
  wsl.defaultUser = "inaccuratetank";

  networking.hostName = "heat";

  environment.systemPackages = with pkgs; [
    git
  ];

  users.users.inaccuratetank = {
    isNormalUser = true;
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "23.11";
}
