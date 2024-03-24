{pkgs, ...}: {
  users.users.control = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    openssh.authorizedKeys.keyFiles = [
      ../keys/id_inacct.pub
    ];
    hashedPasswordFile = "/nix/persist/passwords/control";
    packages = with pkgs; [
      git
    ];
  };
}
