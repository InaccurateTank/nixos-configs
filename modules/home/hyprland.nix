{
  inputs,
  pkgs,
  ...
}: {
  home.sessionVariables = {NIXOS_OZONE_WL = "1";};
  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    xwayland.enable = true;
    settings = {
      monitor = ",preferred,auto,1";

      input = {
        kb_layout = "us";
        follow_mouse = 1;
        sensitivity = 0;
        touchpad = {
          natural_scroll = "no";
          tap-and-drag = true;
        };
      };

      general = {
        gaps_in = 5;
        gaps_out = 5;
        border_size = 1;
        "col.active_border" = "rgba(6C6F93aa)";
        "col.inactive_border" = "rgba(2E303Eaa)";
        layout = "dwindle";
        resize_on_border = true;
        no_focus_fallback = true;
        allow_tearing = false;
      };

      decoration = {
        rounding = 4;
        active_opacity = 1.0;
        inactive_opacity = 0.9;

        # Drop Shadow
        drop_shadow = true;
        shadow_range = 4;
        shadow_render_power = 3;
        "col.shadow" = "rgba(1a1a1aee)";

        blur = {
          enabled = true;
          size = 2;
          passes = 1;
        };
      };

      animations = {
        enabled = true;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      gestures = {
        workspace_swipe = false;
      };

      misc = {
        force_default_wallpaper = -1;
      };

      windowrulev2 = [
        "float, class:thunar, title:^(.*)(Preferences)$"
        "size 50% 70%, class:thunar, title:^(.*)(Preferences)$"
        "center, class:thunar, title:^(.*)(Preferences)$"

        # File Dialogs
        "float, title:^(Save)(.*)$"
        "size 50% 70%, title:(Save)(.*)$"
        "pin, move 50% 30%, title:^(Save)(.*)$"

        "float, title:^(Open)(.*)$"
        "size 50% 70%, title:(Open)(.*)$"
        "pin, move 50% 30%, title:^(Open)(.*)$"
      ];

      "$mod" = "SUPER";

      # Standard Binds
      bind = [
        # Program Hotkeys
        "$mod, Q, exec, wezterm"
        "$mod, R, exec, wofi --show drun"
        "$mod, F, exec, thunar"
        "$mod, W, exec, firefox"

        "$mod, C, killactive,"
        "$mod, V, togglefloating,"
        "$mod, M, exit,"

        # Move Focus
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"

        # Switch Workspaces
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"

        # Move Active Window To Workspace
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 10"

        # Scroll Through Workspaces
        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up, workspace, e-1"
      ];

      bindm = [
        # Move/resize windows with mainMod + LMB/RMB and dragging
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
    };
  };
}
