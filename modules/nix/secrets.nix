{
  config,
  lib,
  inputs,
  flakeRoot,
  ...
}: let
  cfg = config.flakeMods.secrets;
in {
  options.flakeMods.secrets = {
    enable = lib.mkEnableOption "machine secrets management";

    useSshKey = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use the host ssh key as the decryption key";
    };
  };

# TODO: Swap to persist folder if impermenance is activated
  config = lib.mkIf cfg.enable {
    sops = {
      defaultSopsFile = "${inputs.secrets}/${config.networking.hostName}.yaml";
      validateSopsFiles = false;
      age =
        {
          keyFile = "/nix/persist/var/lib/sops-nix/key.txt";
        }
        // lib.optionalAttrs cfg.useSshKey {
          sshKeyPaths = ["/nix/persist/etc/ssh/ssh_host_ed25519_key"];
          generateKey = true;
        };
    };
  };
}
