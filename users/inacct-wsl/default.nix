{...}: {
  users.users.inacct = {
    isNormalUser = true;
    extraGroups = ["wheel"];
  };

  home-manager.users.inacct = ./home.nix;
}
