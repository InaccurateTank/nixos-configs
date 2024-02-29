{
  config,
  lib,
  pkgs,
  ...
}: {
  users.users.inaccuratetank = {
    isNormalUser = true;
    extraGroups = ["wheel"];
  };
  home-manager.users.inaccuratetank = ./home;
}
