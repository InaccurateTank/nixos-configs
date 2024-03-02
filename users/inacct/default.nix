{inputs, ...}: {
  users.users.inacct = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    hashedPasswordFile = "/nix/persist/passwords/inacct";
  };

  home-manager.users.inacct = ./home.nix;
}
