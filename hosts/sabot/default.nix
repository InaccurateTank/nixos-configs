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
    shell-prompt.enable = true;
    btrfs-persist = {
      enable = true;
      extraDirs = [
        "/etc/NetworkManager/system-connections"
      ];
    };
  };

  boot = {
    plymouth = {
      enable = true;
      theme = "nixos-bgrt";
      themePackages = [pkgs.nixos-bgrt-plymouth];
    };

    # Silent Boot
    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];

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

  time = {
    timeZone = "America/Los_Angeles";
    hardwareClockInLocalTime = true;
  };

  # environment.persistence."/persist" = {
  #   # hideMounts = true;
  #   directories = [
  #     "/etc/NetworkManager/system-connections" # NetworkManager Passwords
  #   ];
  # };

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
    steam = {
      enable = true;
      gamescopeSession.enable = true;
    };
    gamemode.enable = true;
  };

  security.rtkit.enable = true;
  services = {
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      wireplumber = {
        enable = true;
        configPackages = [
          (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/alsa.conf" ''
            monitor.alsa.rules = [
              {
                matches = [
                  {
                    device.name = "~alsa_card.*"
                  }
                ]
                actions = {
                  update-props = {
                    # Device settings
                    api.alsa.use-acp = true
                  }
                }
              }
              {
                matches = [
                  {
                    node.name = "~alsa_input.pci.*"
                  }
                  {
                    node.name = "~alsa_output.pci.*"
                  }
                ]
                actions = {
                # Node settings
                  update-props = {
                    session.suspend-timeout-seconds = 0
                  }
                }
              }
            ]
          '')
        ];
      };
      pulse.enable = true;
    };
    gvfs.enable = true;
    tumbler.enable = true;
    greetd = {
      enable = true;
      settings.default_session.command = "${pkgs.cage}/bin/cage -ds -m last ${inputs.ags.packages.${pkgs.system}.ags}/bin/ags -- -c ${./greeter.js}";
    };
    xserver.videoDrivers = ["amdgpu"];
    # flatpak.enable = true;
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # hardware.opengl = {
  #   enable = true;
  #   driSupport = true;
  #   driSupport32Bit = true;
  # };

  # Launcher button doesn't work as expected, disable.
  documentation.nixos.enable = false;

  users.mutableUsers = false;

  system = {
    stateVersion = "23.11";
  };
}
