{
  inputs,
  ...
}: {
  imports = [
    inputs.hyprland.homeManagerModules.default
  ];

  home = {
    username = "inacct";
    homeDirectory = "/home/inacct";
    stateVersion = "23.11";
  };

  programs = {
    kitty.enable = true;
    git.enable = true;
    btop.enable = true;
    hyfetch = {
      enable = true;
      settings = {
        preset = "nonbinary";
        mode = "8bit";
        brightness = "0.50";
        color_align.mode = "horizontal";
      };
    };
  };

  # wayland.windowManager.hyprland = {
  #   enable = true;
  #   package = hyprland;
  #   xwayland.enable = true;
  # };
}
