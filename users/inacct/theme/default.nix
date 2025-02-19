{
  inputs,
  pkgs,
  ...
}: {
  home = {
    packages = with pkgs; [
      cantarell-fonts
      iosevka
      nerd-fonts.symbols-only
    ];
    pointerCursor = {
      name = "catppuccin-mocha-dark-cursors";
      package = pkgs.catppuccin-cursors.mochaDark;
      size = 22;
    };
  };

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      monospace = [
        "Iosevka"
        "Symbols Nerd Font Mono"
      ];
      sansSerif = [
        "Cantarell"
        "Symbols Nerd Font"
      ];
      serif = [
        "DejaVu Serif"
        "Symbols Nerd Font"
      ];
    };
  };

  #GTK Theme
  gtk = {
    enable = true;
    font = {
      name = "Cantarell";
      # package = pkgs.cantarell-fonts;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-nord.override {
        accent = "aurorared";
      };
    };
    theme = {
      name = "adw-gtk3";
      package = pkgs.adw-gtk3;
    };
    cursorTheme = {
      name = "Catppuccin-Mocha-Dark-Cursors";
      package = pkgs.catppuccin-cursors.mochaDark;
      size = 22;
    };
  };

  # GTK Theme Color Overrides
  xdg.configFile."gtk-3.0/gtk.css" = {
    enable = true;
    source = ./horizon-dark.css;
  };
  xdg.configFile."gtk-4.0/gtk.css" = {
    enable = true;
    source = ./horizon-dark.css;
  };

  # QT Theme
  qt = {
    enable = true;
    platformTheme.name = "gtk3";
    style.name = "kvantum";
  };

  xdg.configFile."Kvantum/KvLibadwaita" = {
    enable = true;
    recursive = true;
    source = "${inputs.kvlibadwaita}/src/KvLibadwaita";
  };
  xdg.configFile."Kvantum/kvantum.kvconfig" = {
    enable = true;
    text = ''
      [General]
      theme=KvLibadwaitaDark
    '';
  };
}
