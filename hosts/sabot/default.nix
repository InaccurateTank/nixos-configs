{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  flakeMods = {
    hyprland.enable = true;
    secrets.enable = true;
    btrfs-persist.enable = true;
  };

  boot = {
    plymouth = {
      enable = true;
      theme = "nixos-bgrt";
      themePackages = [pkgs.nixos-bgrt-plymouth];
    };
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        devices = ["nodev"];
        efiSupport = true;
        useOSProber = true;
      };
    };
  };

  time.timeZone = "America/Los_Angeles";

  environment.persistence."/persist" = {
    # hideMounts = true;
    directories = [
      "/etc/NetworkManager/system-connections" # NetworkManager Passwords
    ];
  };

  environment.systemPackages = with pkgs; [
    xdg-terminal-exec
    xdg-utils
    networkmanagerapplet
  ];

  networking.networkmanager.enable = true;

  security.sudo.extraConfig = ''
    Defaults lecture = never
  '';

  programs = {
    zsh.enable = true;
    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-volman
        thunar-archive-plugin
        thunar-media-tags-plugin
      ];
    };
  };

  security.rtkit.enable = true;
  services = {
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      wireplumber.enable = true;
      pulse.enable = true;
    };
    gvfs.enable = true;
    tumbler.enable = true;
    greetd = {
      enable = true;
      settings.default_session.command = "${pkgs.cage}/bin/cage -ds -m last ${inputs.ags.packages.${pkgs.system}.ags}/bin/ags -- -c ${./greeter.js}";
    };
  };

  # Launcher button doesn't work as expected, disable.
  documentation.nixos.enable = false;

  users.mutableUsers = false;

  system = {
    stateVersion = "23.11";
  };
}
