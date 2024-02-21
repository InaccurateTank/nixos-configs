{ config, lib, pkgs, ... }:

let
  fetchKeys = username:(builtins.fetchurl {
    url = "https://github.com/${username}.keys";
    sha256 = "sha256:0c0b3c3kx3z7hlc5bl1bl30mvc3z9afpmsrikzq49wgl7zpnjpyy";
  });
in {
  users.users.control = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keyFiles = [ (fetchKeys "inaccuratetank") ];
    hashedPasswordFile = "/nix/persist/passwords/control";
  };
}