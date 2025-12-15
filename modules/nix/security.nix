{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.flakeMods.security;
in {
  options.flakeMods.security = {
    enable =
      lib.mkEnableOption "flake security preset"
      // {default = true;};

    # Apparmor completely fails on wsl so add an option to disable it.
    apparmor.enable =
      lib.mkEnableOption "apparmor for the security preset"
      // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    # Enable Firewall
    networking.firewall.enable = true;

    # Only sudoers can use nix
    # Would be "root" but that breaks home-manager
    nix.settings.allowed-users = ["@wheel"];

    # programs.ssh.kexAlgorithms = config.services.openssh.settings.KexAlgorithms;

    # Basic sudo stuff
    security.sudo = {
      execWheelOnly = true;
      wheelNeedsPassword = true;
    };

    # SSH Security
    services.openssh = {
      allowSFTP = false;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        X11Forwarding = false;
        # KexAlgorithms = [
        #   "sntrup761x25519-sha512"
        #   "sntrup761x25519-sha512@openssh.com"
        #   "mlkem768x25519-sha256"
        # ];
      };
      extraConfig = ''
        AllowTcpForwarding yes
        AllowAgentForwarding no
        AllowStreamLocalForwarding no
        AuthenticationMethods publickey
      '';
    };

    # *Completely* disable root login
    users.users.root.hashedPassword = "!";

    # AppArmor
    security.apparmor = lib.mkIf cfg.apparmor.enable {
      enable = true;
      packages = with pkgs; [
        apparmor-utils
        apparmor-profiles
      ];
    };

    # Enable TPM support
    security.tpm2 = {
      enable = true;
      pkcs11.enable = true;
      tctiEnvironment.enable = true;
    };
  };
}
