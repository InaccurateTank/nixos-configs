{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
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
  };

  programs.zsh.enable = true;

  users = {
    mutableUsers = false;
    defaultUserShell = pkgs.zsh;
  };

  system = {
    stateVersion = "23.11";
  };
}
