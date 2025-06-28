{...}: {
  imports = [
    ./default.nix
  ];

  users.users.control = {
    linger = true;
    autoSubUidGidRange = true;
  };

  home-manager.users.control = {...}: {
    home = {
      username = "control";
      homeDirectory = "/home/control";
      stateVersion = "25.05";
    };

    systemd.user.startServices = "sd-switch";

    flakeMods.quadlets.jellyfin.enable = true;

    virtualisation.quadlet.autoUpdate.enable = true;
  };
}
