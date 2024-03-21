{pkgs, ...}: {
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
}
