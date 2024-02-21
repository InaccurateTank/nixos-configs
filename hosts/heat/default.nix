{ nixos-wsl, ... }:
{ config, lib, pkgs, ... }:

{
  imports = [
    nixos-wsl.nixosModules.wsl
  ];

  wsl = {
    enable = true;
    defaultUser = "inaccuratetank";
    interop.includePath = true;
    nativeSystemd = true;
  };

  environment.systemPackages = with pkgs; [
    git
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "23.11";
}
