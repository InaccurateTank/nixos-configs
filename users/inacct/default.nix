{
  inputs,
  pkgs,
  ...
}: {
  users.users.inacct = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
    openssh.authorizedKeys.keyFiles = [
      ../keys/id_inacct.pub
    ];
    hashedPasswordFile = "/nix/persist/passwords/inacct";
  };

  home-manager.users.inacct = ./home.nix;
}
