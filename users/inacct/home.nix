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
    wezterm = {
      enable = true;
      package = pkgs.unstable.wezterm;
    };
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
}
