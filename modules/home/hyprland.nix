{...}: {
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    settings = {
      "$mod" = "SUPER";

      # Standard Binds
      bind = [
        "$mod, Q, exec, wezterm"
        "$mod, C, killactive"
        "$mod, V, togglefloating"
        # Move Focus
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"
      ];
    };
  };
}
