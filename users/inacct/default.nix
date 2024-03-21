{
  inputs,
  pkgs,
  ...
}: let
  fetchKeys = username: (builtins.fetchurl {
    url = "https://github.com/${username}.keys";
    sha256 = "sha256:0c0b3c3kx3z7hlc5bl1bl30mvc3z9afpmsrikzq49wgl7zpnjpyy";
  });
in {
  users.users.inacct = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
    openssh.authorizedKeys.keyFiles = [(fetchKeys "inaccuratetank")];
    hashedPasswordFile = "/nix/persist/passwords/inacct";
  };

  home-manager.users.inacct = ./home.nix;
}
