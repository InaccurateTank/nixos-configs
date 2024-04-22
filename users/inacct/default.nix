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

  environment.persistence."/persist".users.inacct = {
    directories = [
      "Downloads"
      "Music"
      "Pictures"
      "Documents"
      "Videos"

      # Program settings
      ".cache/swww"
      ".config/vesktop"
      ".vscode"
      ".mozilla"
    ];
  };

  home-manager.users.inacct = ./home.nix;
}
