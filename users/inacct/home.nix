{
  inputs,
  pkgs,
  ...
}: let
  hyprland = inputs.hyprland.packages.${pkgs.system}.hyprland;
in {
  imports = [
    inputs.hyprland.homeManagerModules.default
  ];

  home = {
    username = "inacct";
    homeDirectory = "/home/inacct";
    stateVersion = "23.11";
    packages = with pkgs; [
      macchina
    ];
  };

  programs = {
    git.enable = true;
    btop.enable = true;
  };

  # wayland.windowManager.hyprland = {
  #   enable = true;
  #   package = hyprland;
  #   xwayland.enable = true;
  # };
}
