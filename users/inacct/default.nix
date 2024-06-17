{pkgs, ...}: {
  users.users.inacct = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = ["wheel"];
    openssh.authorizedKeys.keyFiles = [
      ../keys/id_inacct.pub
    ];
  };

  home-manager.users.inacct = ./home.nix;
}
