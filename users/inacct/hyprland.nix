{
  inputs,
  pkgs,
  ...
}: let
  grim = "${pkgs.grim}/bin/grim";
  slurp = "${pkgs.slurp}/bin/slurp";
  eags = "exec, ags -b hypr";
  wl-copy = "${pkgs.wl-clipboard}/bin/wl-copy";
  wl-paste = "${pkgs.wl-clipboard}/bin/wl-paste";
  grimblast = "${inputs.hyprland-contrib.packages.${pkgs.system}.grimblast}/bin/grimblast";
  # cliphist = "${pkgs.cliphist}/bin/cliphist";
in {
  imports = [
    inputs.hypridle.homeManagerModules.hypridle
    inputs.hyprlock.homeManagerModules.hyprlock
  ];

  home.packages = [pkgs.swww];

  # flakeMods.swww.enable = true;

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
    general = {
      ignore_empty_input = true;
    };
    backgrounds = [
      {
        path = "screenshot";
        blur_size = 4;
        blur_passes = 3;
      }
    ];
    input-fields = [
      {
        dots_size = 0.2;
        dots_spacing = 0.64;
        dots_rounding = 2;
        rounding = 10;
        position = {
          x = 0;
          y = 70;
        };
        valign = "bottom";
      }
    ];
    labels = [
      # Clock
      {
        text = "cmd[update:1000] echo \"<b><big> $(date +\"%I:%M\") </big></b>\"";
        text_align = "center";
        font_size = 64;
        font_family = "Iosevka";
        position = {
          x = 0;
          y = 16;
        };
      }
      # Welcome
      {
        text = "Welcome Back $USER";
        text_align = "center";
        font_size = 16;
        font_family = "Iosevka";
        position = {
          x = 0;
          y = 0;
        };
      }
      # Reminder
      {
        text = "Type to Unlock!";
        text_align = "center";
        font_size = 16;
        font_family = "Iosevka";
        position = {
          x = 0;
          y = 30;
        };
        valign = "bottom";
      }
    ];
  };

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    plugins = [
      inputs.hyprland-plugins.packages.${pkgs.system}.hyprexpo
      inputs.hy3.packages.${pkgs.system}.hy3
    ];
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
        # layout = "dwindle";
        layout = "hy3";
        resize_on_border = true;
        no_focus_fallback = true;
        allow_tearing = false;
      };

      plugin = {
        hy3 = {
          tabs = {
            height = "2";
            padding = "6";
            render_text = "false";
          };
          autotile = {
            enable = true;
            trigger_width = "800";
            trigger_height = "500";
          };
        };
        hyprexpo = {
          bg_col = "rgba(6C6F93aa)";
        };
      };

      decoration = {
        rounding = 0;
        active_opacity = 1.0;
        inactive_opacity = 0.9;

        # Drop Shadow
        drop_shadow = true;
        shadow_range = 4;
        shadow_render_power = 3;
        "col.shadow" = "rgba(1a1a1aee)";

        blur = {
          enabled = true;
          size = 4;
          passes = 3;
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

        # Network Manager
        "float, class:nm-connection-editor"

        # Firefox PnP
        "float, class:firefox, title:Picture-in-Picture"
      ];

      exec-once = [
        "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
        "swww-daemon"
        "ags -b hypr"
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
      ];

      # Nonconsuming Push-to-Toggle-Talk
      bindn = [
        ",KP_Subtract, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
      ];

      # Standard Binds
      bind = [
        # Program Hotkeys
        "SUPER, S, ${eags} -t quicksettings"
        "SUPER, R, ${eags} -t launcher"
        "SUPER, grave, exec, [float;tile] wezterm start --always-new-process"
        "SUPER, F, exec, thunar"
        "SUPER, W, exec, firefox"

        # Screenshot: Probably migrate to grimblast
        # "SUPER SHIFT, S, exec, ${grim} -g \"$(${slurp})\" - | ${wl-copy} && ${wl-paste} > ~/Pictures/Screenshots/Screenshot-$(date +%F_%T).png"
        ",Print, exec, ${grimblast} --notify copy screen"
        "SHIFT, Print, exec, ${grimblast} --notify copy screen"
        "SUPER, Print, exec, ${grimblast} --notify save area"
        "SUPER SHIFT, Print, exec, ${grimblast} --notify save area"

        "SUPER, C, killactive,"
        "SUPER, V, togglefloating,"
        "SUPER, Tab, hyprexpo:expo, toggle" # Hyprexpo used for overview

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
