{pkgs, ...}: {
  imports = [
    ../../modules/home/hyprland.nix
  ];

  home = {
    username = "inacct";
    homeDirectory = "/home/inacct";
    stateVersion = "23.11";
  };

  programs = {
    wezterm.enable = true;
    firefox.enable = true;
    git.enable = true;
    btop.enable = true;
    hyfetch = {
      enable = true;
      settings = {
        preset = "nonbinary";
        mode = "rgb";
        brightness = "0.50";
        color_align.mode = "horizontal";
      };
    };
  };

  xdg.configFile."wezterm" = {
    enable = true;
    recursive = true;
    source = ./wezterm;
  };
}
