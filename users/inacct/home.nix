{pkgs, ...}: {
  imports = [
    ../../modules/home/hyprland.nix
  ];

  home = {
    username = "inacct";
    homeDirectory = "/home/inacct";
    stateVersion = "23.11";
    pointerCursor = {
      name = "Catppuccin-Mocha-Dark-Cursors";
      package = pkgs.catppuccin-cursors.mochaDark;
      size = 22;
    };
    packages = with pkgs; [
      flakePkgs.iosevka-tonk
      flakePkgs.iosevka-tonk-term
    ];
  };

  fonts.fontconfig.enable = true;

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
    thefuck.enable = true;
  };

  gtk = {
    enable = true;
    font = {
      name = "Cantarell";
      package = pkgs.cantarell-fonts;
    };
    iconTheme = {
      name = "Nordzy-red-dark";
      package = pkgs.nordzy-icon-theme.override {
        nordzy-themes = ["red"];
      };
    };
    theme = {
      name = "horizon-theme";
      package = pkgs.flakePkgs.horizon-theme;
    };
    cursorTheme = {
      name = "Catppuccin-Mocha-Dark-Cursors";
      package = pkgs.catppuccin-cursors.mochaDark;
      size = 22;
    };
  };

  xdg.configFile."wezterm" = {
    enable = true;
    recursive = true;
    source = ./wezterm;
  };
}
