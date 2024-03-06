{pkgs, ...}: {
  imports = [
    ../../modules/home/hyprland.nix
  ];

  home = {
    username = "inacct";
    homeDirectory = "/home/inacct";
    stateVersion = "23.11";
    packages = with pkgs; [
      xfce.thunar
    ];
  };

  programs = {
    wezterm.enable = true;
    wezterm.extraConfig = ''
      return {
        enable_wayland=false,
        use_fancy_tab_bar=false
      }
    '';

    firefox.enable = true;

    git.enable = true;
    btop.enable = true;
    hyfetch = {
      enable = true;
      settings = {
        preset = "nonbinary";
        mode = "8bit";
        brightness = "0.50";
        color_align.mode = "horizontal";
      };
    };
  };
}
