{
  pkgs,
  config,
  ...
}: {
  sops.secrets."controlPass".neededForUsers = true;

  users.users.control = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    openssh.authorizedKeys.keyFiles = [
      ../../keys/id_inacct.pub
    ];
    hashedPasswordFile = config.sops.secrets."controlPass".path;
    packages = with pkgs; [
      git
    ];
  };
}
