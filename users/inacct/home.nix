{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.ags.homeManagerModules.default
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
    file."firefox-gnome-theme" = {
      target = ".mozilla/firefox/default/chrome/firefox-gnome-theme";
      source = inputs.firefox-gnome-theme;
    };
  };

  fonts.fontconfig.enable = true;

  programs = {
    ags = {
      enable = true;
      configDir = ./ags;
    };
    wezterm.enable = true;
    firefox = {
      enable = true;
      profiles.default = {
        name = "Default";
        id = 0;
        settings = {
          # For Firefox GNOME theme:
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true; # Enable customChrome.cs
          "browser.uidensity" = 0; # Set UI density to normal
          "svg.context-properties.content.enabled" = true; # Enable SVG context-propertes
        };
        userChrome = ''
          @import "firefox-gnome-theme/userChrome.css";
        '';
        userContent = ''
          @import "firefox-gnome-theme/userContent.css";
        '';
      };
    };
    git.enable = true;
    btop = {
      enable = true;
      settings = {
        color_theme = "horizon";
        theme_background = false;
        rounded_corners = false;
        proc_gradient = false;
      };
    };
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
    theme = {
      name = "phocus-gtk";
      package = pkgs.flakePkgs.phocus-gtk;
    };
    # theme = {
    #   name = "adw-gtk3-horizon";
    #   package = pkgs.flakePkgs.adw-gtk3-horizon;
    # };
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

  xdg = {
    mimeApps = {
      enable = true;
      defaultApplications = {
        "inode/directory" = "thunar.desktop";
      };
    };
    configFile."wezterm" = {
      enable = true;
      recursive = true;
      source = ./wezterm;
    };
  };
}
