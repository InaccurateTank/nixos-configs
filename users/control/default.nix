{
  flakeLib,
  pkgs,
  config,
  ...
}: {
  sops.secrets."controlPass".neededForUsers = true;

  users.users.control = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    openssh.authorizedKeys.keyFiles = flakeLib.fetchPubKeys ["id_inacct"];

    hashedPasswordFile = config.sops.secrets."controlPass".path;

    packages = with pkgs; [
      git
    ];
  };
}
