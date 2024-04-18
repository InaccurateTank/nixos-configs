{
  inputs,
  pkgs,
  config,
  ...
}: {
  sops.secrets."inacctPass".neededForUsers = true;

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
    hashedPasswordFile = config.sops.secrets."inacctPass".path;
  };

  environment.persistence."/nix/persist".users.inacct = {
    directories = [
      "Downloads"
      "Music"
      "Pictures"
      "Documents"
      "Videos"
      ".cache/swww"
    ];
  };

  home-manager.users.inacct = ./home.nix;
}
