{
  pkgs,
  inputs,
  config,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  flakeMods = {
    auto-upgrade = {
      enable = true;
      # Game servers being shut down automatically kinda screws things.
      reboot = false;
      # The VMs are relatively small...
      maxJobs = 1;
    };
    impermanence = {
      enable = true;
      extraDirs = [
        "/etc/pelican"
      ];
    };
    secrets = {
      enable = true;
      useSshKey = true;
    };
    # Nerd fonts make things weird on the host, but 99% of the time we're interacting via ssh anyway.
    shell-prompt.enable = true;
    vscode-remote-fix.enable = true;
    pelican = {
      panel = {
        enable = true;
        http = true;
        domain = "gpanel.inaccuratetank.gay";
      };
      wings = {
        enable = true;
      };
    };
  };

  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
  };

  time.timeZone = "America/Los_Angeles";

  security.sudo.extraConfig = ''
    Defaults lecture = never
  '';

  networking.firewall.allowedTCPPorts = [
    # Caddy / Pelican Panel
    80
    443
    # Pelican
    8080
    # Pelican SFTP
    2022
  ];

  virtualisation.docker.rootless.enable = true;

  services = {
    openssh.enable = true;
    qemuGuest.enable = true;
  };

  programs.zsh.enable = true;

  users = {
    mutableUsers = false;
    defaultUserShell = pkgs.zsh;
  };

  system = {
    stateVersion = "25.11";
  };
}
