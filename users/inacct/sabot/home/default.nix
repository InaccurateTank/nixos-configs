{
  config,
  pkgs,
  ...
}: {
  home = {
    username = "inacct";
    homeDirectory = "/home/inacct";
    stateVersion = "23.11";
  };
  programs.home-manager.enable = true;
}
