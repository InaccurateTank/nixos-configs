{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.ags.homeManagerModules.default
    # inputs.nix-flatpak.homeManagerModules.nix-flatpak
    ./hyprland.nix
    ./theme
  ];

  home = {
    packages = with pkgs; [
      loupe # Gnome Image Viewer
      evince # Gnome PDF Viewer
      celluloid # Video Player
      vesktop # Discord Client

      # Temp Insert
      wl-clipboard
      cliphist
    ];
    file."firefox-gnome-theme" = {
      target = ".mozilla/firefox/default/chrome/firefox-gnome-theme";
      source = inputs.firefox-gnome-theme;
    };
  };

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
        search = {
          force = true;
          default = "ddg";
          order = ["ddg"];
          engines = {
            "Nix Packages" = {
              urls = [
                {
                  template = "https://search.nixos.org/packages";
                  params = [
                    {
                      name = "type";
                      value = "packages";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              icon = "''${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = ["@np"];
            };
            "Rust Docs" = {
              urls = [
                {
                  template = "https://docs.rs/releases/search?query={searchTerms}";
                }
              ];
              icon = "https://docs.rs/favicon.ico";
              definedAliases = ["@rs"];
            };
          };
        };
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
      profiles.default.userSettings = {
        "workbench.colorTheme" = "Horizon";
        "editor.fontFamily" = "'Iosevka Expanded', 'Symbols Nerd Font'";
        "editor.fontSize" = 13;
        "editor.fontLigatures" = true;
        "terminal.integrated.fontFamily" = "Iosevka, 'Symbols Nerd Font Mono'";
        "terminal.integrated.fontSize" = 13;
        "terminal.integrated.shellIntegration.enabled" = false;
      };
    };
  };

  # services.flatpak = {
  #   enable = true;
  #   uninstallUnmanaged = false;
  #   update.auto.enable = true;
  #   packages = [
  #     "com.valvesoftware.Steam"
  #     "org.freedesktop.Platform.VulkanLayer.gamescope"
  #     "io.github.Foldex.AdwSteamGtk"
  #   ];
  # };

  gtk.gtk3.bookmarks = [
    "file:///home/inacct/Downloads"
    "file:///home/inacct/Documents"
    "file:///home/inacct/Music"
    "file:///home/inacct/Pictures"
    "file:///home/inacct/Videos"
  ];

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
