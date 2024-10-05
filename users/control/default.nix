{
  pkgs,
  config,
  ...
}: {
  # sops.secrets."controlPass".neededForUsers = true;

  users.users.control = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    openssh.authorizedKeys.keyFiles = [
      ../keys/id_inacct.pub
    ];

    # Due to issues, password secret doesnt work anymore. Not like this VM works rn anyway.
    initialPassword = "transrights";
    # hashedPasswordFile = config.sops.secrets."controlPass".path;

    packages = with pkgs; [
      git
    ];
  };
}
