{
  inputs,
  pkgs,
  ...
}: let
  grim = "${pkgs.grim}/bin/grim";
  slurp = "${pkgs.slurp}/bin/slurp";
in {
  imports = [
    inputs.hypridle.homeManagerModules.hypridle
    inputs.hyprlock.homeManagerModules.hyprlock
  ];

  services.hypridle = {
    enable = true;
    lockCmd = "hyprlock";
    beforeSleepCmd = "loginctl lock-session";
    afterSleepCmd = "hyprctl dispatch dpms on";
    listeners = [
      {
        # Lockscreen after 5 mins
        timeout = 300;
        onTimeout = "loginctl lock-session";
      }
      {
        # Screen off after 10 mins
        timeout = 600;
        onTimeout = "hyprctl dispatch dpms off";
        onResume = "hyprctl dispatch dpms on";
      }
    ];
  };

  programs.hyprlock = {
    enable = true;
  };

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
        force_default_wallpaper = 0;
        focus_on_activate = true;
        disable_hyprland_logo = 1;
        disable_splash_rendering = 1;
      };

      windowrulev2 = [
        "float, class:thunar, title:^(.*)(Preferences)$"
        "maxsize 50% 70%, class:thunar, title:^(.*)(Preferences)$"
        "center, class:thunar, title:^(.*)(Preferences)$"

        # File Dialogs
        "float, title:^(Save)(.*)$"
        "size 50% 70%, title:^(Save)(.*)$"
        "pin, move 50% 30%, title:^(Save)(.*)$"

        "float, title:^(Open)(.*)$"
        "size 50% 70%, title:^(Open)(.*)$"
        "pin, move 50% 30%, title:^(Open)(.*)$"
      ];

      exec-once = [
        "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
        "ags -b hypr"
      ];

      # Standard Binds
      bind = let
        eags = "exec, ags -b hypr";
      in [
        # Program Hotkeys
        "SUPER, Q, exec, wezterm"
        "SUPER, R, ${eags}, -t launcher"
        "SUPER, F, exec, thunar"
        "SUPER, W, exec, firefox"

        # Screenshot
        "SUPER SHIFT, S, exec, ${grim} -g \"$(${slurp})\""

        "SUPER, C, killactive,"
        "SUPER, V, togglefloating,"
        # "SUPER, M, exit,"

        # Move Focus
        "SUPER, left, movefocus, l"
        "SUPER, right, movefocus, r"
        "SUPER, up, movefocus, u"
        "SUPER, down, movefocus, d"

        # Switch Workspaces
        "SUPER, 1, workspace, 1"
        "SUPER, 2, workspace, 2"
        "SUPER, 3, workspace, 3"
        "SUPER, 4, workspace, 4"
        "SUPER, 5, workspace, 5"
        "SUPER, 6, workspace, 6"
        "SUPER, 7, workspace, 7"
        "SUPER, 8, workspace, 8"
        "SUPER, 9, workspace, 9"
        "SUPER, 0, workspace, 10"

        # Move Active Window To Workspace
        "SUPER SHIFT, 1, movetoworkspace, 1"
        "SUPER SHIFT, 2, movetoworkspace, 2"
        "SUPER SHIFT, 3, movetoworkspace, 3"
        "SUPER SHIFT, 4, movetoworkspace, 4"
        "SUPER SHIFT, 5, movetoworkspace, 5"
        "SUPER SHIFT, 6, movetoworkspace, 6"
        "SUPER SHIFT, 7, movetoworkspace, 7"
        "SUPER SHIFT, 8, movetoworkspace, 8"
        "SUPER SHIFT, 9, movetoworkspace, 9"
        "SUPER SHIFT, 0, movetoworkspace, 10"

        # Scroll Through Workspaces
        "SUPER, mouse_down, workspace, e+1"
        "SUPER, mouse_up, workspace, e-1"
      ];

      bindm = [
        # Move/resize windows with mainMod + LMB/RMB and dragging
        "SUPER, mouse:272, movewindow"
        "SUPER, mouse:273, resizewindow"
      ];
    };
  };
}
