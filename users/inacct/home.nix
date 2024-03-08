{pkgs, ...}: {
  imports = [
    ../../modules/home/hyprland.nix
  ];

  home = {
    username = "inacct";
    homeDirectory = "/home/inacct";
    stateVersion = "23.11";
    pointerCursor = {
      name = "mochaLight";
      package = pkgs.catppuccin-cursors.mochaLight;
      size = 22;
    };
  };

  programs = {
    wezterm.enable = true;
    firefox.enable = true;
    git.enable = true;
    btop.enable = true;
    vscode.enable = true;
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

  gtk = {
    enable = true;
    iconTheme = {
      name = "Nordzy-red-dark";
      package = pkgs.nordzy-icon-theme.override {
        nordzy-themes = ["red"];
      };
    };
    theme = {
      name = "horizon-theme";
      package = pkgs.callPackage ../../pkgs/horizon-theme.nix {};
    };
    cursorTheme = {
      name = "mochaLight";
      package = pkgs.catppuccin-cursors;
      size = 22;
    };
  };

  xdg.configFile."wezterm" = {
    enable = true;
    recursive = true;
    source = ./wezterm;
  };
}
