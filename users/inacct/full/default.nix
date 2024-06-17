{
  inputs,
  pkgs,
  config,
  ...
}: {
  imports = [
    ../default.nix
  ];

  sops.secrets."inacctPass".neededForUsers = true;

  users.users.inacct = {
    extraGroups = ["networkmanager"];
    hashedPasswordFile = config.sops.secrets."inacctPass".path;
  };

  home-manager.users.inacct = ./home.nix;
}
