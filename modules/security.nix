{ ... }:

{
    networking.firewall.enable = true;
    nix.settings.allowed-users = [ "root" ];
    security.sudo.execWheelOnly = true;
    services.openssh = {
      allowSFTP = false;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        X11Forwarding = false;
      };
      extraConfig = ''
        AllowTcpForwarding yes
        AllowAgentForwarding no
        AllowStreamLocalForwarding no
        AuthenticationMethods publickey
        '';
    };
}