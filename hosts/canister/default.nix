{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    inputs.quadlet-nix.nixosModules.quadlet
  ];

  flakeMods = {
    auto-upgrade = {
      enable = true;
      reboot = true;
      # The VMs are relatively small...
      maxJobs = 1;
    };
    impermanence.enable = true;
    secrets = {
      enable = true;
      useSshKey = true;
    };
    # Nerd fonts make things weird on the host, but 99% of the time we're interacting via ssh anyway.
    shell-prompt.enable = true;
    vscode-remote-fix.enable = true;
  };

  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
  };

  time.timeZone = "America/Los_Angeles";

  security.sudo.extraConfig = ''
    Defaults lecture = never
  '';

  services = {
    openssh.enable = true;
    qemuGuest.enable = true;
    # Caddy on the host to do the routing.
    caddy = {
      enable = true;
      package = pkgs.flakePkgs.custom-caddy;
    };
  };

  programs.zsh.enable = true;

  users = {
    mutableUsers = false;
    defaultUserShell = pkgs.zsh;
  };

  system = {
    stateVersion = "25.05";
  };
}
