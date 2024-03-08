{pkgs, ...}: {
  imports = [
    ../../modules/home/hyprland.nix
  ];

  home = {
    username = "inacct";
    homeDirectory = "/home/inacct";
    stateVersion = "23.11";
    pointerCursor = {
      name = "Nordzy-cursors";
      package = pkgs.nordzy-cursor-theme;
      size = 22;
    };
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

  gtk = {
    enable = true;
    iconTheme = {
      name = "Colloid-red-dark";
      package = pkgs.colloid-icon-theme.override {
        colorVariants = ["red"];
      };
    };
    theme = {
      name = "horizon-theme";
      package = pkgs.callPackage ../../pkgs/horizon-theme.nix {};
    };
    # theme = {
    #   name = "Catppuccin-Mocha-Compact-Red-Dark";
    #   package = pkgs.catppuccin-gtk.override {
    #     accents = ["red"];
    #     size = "compact";
    #     tweaks = ["rimless"];
    #     variant = "mocha";
    #   };
    # };
    cursorTheme = {
      name = "Nordzy-cursors";
      package = pkgs.nordzy-cursor-theme;
      size = 22;
    };
  };

  xdg.configFile."wezterm" = {
    enable = true;
    recursive = true;
    source = ./wezterm;
  };
}
