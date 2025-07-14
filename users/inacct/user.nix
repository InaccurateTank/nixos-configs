{
  flakeLib,
  pkgs,
  ...
}: {
  users.users.inacct = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = ["wheel"];
    openssh.authorizedKeys.keyFiles = flakeLib.fetchPubKeys ["id_inacct"];
  };
}
