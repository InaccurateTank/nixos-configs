{
  lib,
  config,
  ...
}: {
  imports = [
    ../default.nix
  ];

  sops.secrets."inacctPass".neededForUsers = true;

  users.users.inacct = {
    extraGroups = ["networkmanager"];
    # Since the password is being set other than initial, we need to change this.
    initialPassword = lib.mkForce null;
    hashedPasswordFile = config.sops.secrets."inacctPass".path;
  };

  home-manager.users.inacct = ./home.nix;
}
