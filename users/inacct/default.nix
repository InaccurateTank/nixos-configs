{flakeLib, pkgs, ...}: {
  users.users.inacct = {
    initialPassword = "transrights";
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = ["wheel"];
    openssh.authorizedKeys.keyFiles = flakeLib.fetchPubKeys ["id_inacct"];
  };

  home-manager.users.inacct = ./home;
}
