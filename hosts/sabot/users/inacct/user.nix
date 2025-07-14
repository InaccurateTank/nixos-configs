{
  lib,
  config,
  ...
}: {
  flakeMods.secrets.enable = lib.mkForce true;

  sops.secrets."inacctPass".neededForUsers = true;

  users.users.inacct = {
    extraGroups = ["networkmanager"];
    hashedPasswordFile = config.sops.secrets."inacctPass".path;
  };
}
