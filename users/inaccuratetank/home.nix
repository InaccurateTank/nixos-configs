{ config, pkgs, ... }:

{
  home = {
    username = "inaccuratetank";
    homeDirectory = "/home/inaccuratetank";
    stateVersion = "23.11";
  };

  programs.home-manager.enable = true;
}
