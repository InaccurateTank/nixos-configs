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
    vscode = {
      enable = true;
      userSettings = {
        "workbench.colorTheme" = "Horizon";
        "editor.fontFamily" = "'Iosevka Tonk Expanded'";
        "editor.fontSize" = 13;
        "editor.fontLigatures" = true;
        "terminal.integrated.fontFamily" = "'Iosevka Tonk Term'";
        "terminal.integrated.fontSize" = 13;
        "terminal.integrated.shellIntegration.enabled" = false;
      };
    };
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
    # theme = {
    #   name = "Flat-Remix-GTK-Red-Dark-Solid";
    #   package = pkgs.flat-remix-gtk;
    # };
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

  xfconf.settings = {
    # Thunar config
    thunar = {
      # Hide status and menubar by default.
      "last-menubar-visible" = false;
      "last-statusbar-visible" = false;
    };
  };

  xdg.configFile."wezterm" = {
    enable = true;
    recursive = true;
    source = ./wezterm;
  };
}
