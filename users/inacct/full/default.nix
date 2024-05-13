{
  inputs,
  pkgs,
  config,
  ...
}: {
  imports = [
    ../minimal
  ];

  sops.secrets."inacctPass".neededForUsers = true;

  users.users.inacct = {
    extraGroups = ["networkmanager"];
    hashedPasswordFile = config.sops.secrets."inacctPass".path;
  };

  home-manager.users.inacct = ./home.nix;
}
