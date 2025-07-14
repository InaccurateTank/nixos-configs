{...}: {
  home = {
    username = "control";
    homeDirectory = "/home/control";
    stateVersion = "25.05";
  };

  systemd.user.startServices = "sd-switch";

  flakeMods.quadlets.jellyfin.enable = true;

  virtualisation.quadlet.autoUpdate.enable = true;
}
