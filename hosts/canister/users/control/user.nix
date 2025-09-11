{...}: {
  flakeMods.secrets.enable = lib.mkForce true;

  sops.secrets."controlPass".neededForUsers = true;

  users.users.control = {
    linger = true;
    autoSubUidGidRange = true;
    hashedPasswordFile = config.sops.secrets."controlPass".path;
  };
}
