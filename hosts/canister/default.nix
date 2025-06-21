{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  flakeMods = {
    vscode-remote-fix.enable = true;
    impermanence.enable = true;
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

  users.defaultUserShell = pkgs.zsh;

  system = {
    stateVersion = "23.11";
  };
}
