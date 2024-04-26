{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.ags.homeManagerModules.default
    ./hyprland.nix
    ./theme
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
      # flakePkgs.iosevka-tonk
      # flakePkgs.iosevka-tonk-term
      iosevka # Font

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

  fonts.fontconfig.enable = true;

  programs = {
    zsh = {
      enable = true;
      autosuggestion.enable = true;
      initExtra = ''
        bindkey "^[[1;5C" forward-word
        bindkey "^[[1;5D" backward-word

        function directory-title() {
          # Terminal Name
          print -nP '%{\033]0;%}%n@%m: %~%{\007\\%}'
          # OSC 7
          print -nP '%{\033]7;%}file://%m%d%{\033\\%}'
        }

        add-zsh-hook precmd directory-title

        PROMPT=$'%(!.%F{magenta}.%F{cyan})%~%f %(?.%F{green}.%F{red})❯%f '
        RPROMPT=$'%F{magenta}%n@%m%f'
      '';
    };
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
          default = "DuckDuckGo";
          order = ["DuckDuckGo"];
          engines = {
            "Nix Packages" = {
              urls = [{
                template = "https://search.nixos.org/packages";
                params = [
                  { name = "type"; value = "packages"; }
                  { name = "query"; value = "{searchTerms}"; }
                ];
              }];
              icon = "''${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@np" ];
            };
            "Rust Docs" = {
              urls = [{
                template = "https://docs.rs/releases/search?query={searchTerms}";
              }];
              icon = "https://docs.rs/favicon.ico";
              definedAliases = [ "@rs" ];
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
    git = {
      enable = true;
      userName = "InaccurateTank";
      userEmail = "inaccuratetank@outlook.com";
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
      userSettings = {
        "workbench.colorTheme" = "Horizon";
        "editor.fontFamily" = "'Iosevka Expanded'";
        "editor.fontSize" = 13;
        "editor.fontLigatures" = true;
        "terminal.integrated.fontFamily" = "Iosevka";
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
