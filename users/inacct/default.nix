{inputs, ...}: {
  users.users.inacct = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    openssh.authorizedKeys.keyFiles = [(fetchKeys "inaccuratetank")];
    hashedPasswordFile = "/nix/persist/passwords/inacct";
  };

  home-manager.users.inacct = ./home.nix;
}
