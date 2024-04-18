{
  inputs,
  pkgs,
  ...
}: let
  hyprlandConfig = pkgs.writeText "greetd-hyprland.conf" ''
    exec-once = ${inputs.ags.packages.${pkgs.system}.ags}/bin/ags --config ${./greeter.js}; hyprctl dispatch exit
  '';
in {
  imports = [
    inputs.impermanence.nixosModules.impermanence
    ./hardware-configuration.nix
  ];

  flakeMods = {
    vscode-remote-fix.enable = true;
    hyprland.enable = true;
    secrets = {
      enable = true;
      useSshKey = true;
    };
  };

  boot = {
    plymouth = {
      enable = true;
      theme = "nixos-bgrt";
      themePackages = [pkgs.nixos-bgrt-plymouth];
    };
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  time.timeZone = "America/Los_Angeles";

  environment.persistence."/nix/persist" = {
    hideMounts = true;
    directories = [
      "/etc/nixos" # nixos system config files
      "/var/lib" # system service persistent data
      "/var/log" # the place that journald dumps logs to
      {
        # Secret repo ssh
        directory = "/root/.ssh";
        mode = "0700";
      }
    ];
    files = [
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/machine-id"
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

  services = {
    openssh.enable = true;
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
      settings.default_session.command = "Hyprland --config ${hyprlandConfig}";
    };
  };

  # Launcher button doesn't work as expected, disable.
  documentation.nixos.enable = false;

  users.mutableUsers = false;

  system = {
    stateVersion = "23.11";
  };
}
