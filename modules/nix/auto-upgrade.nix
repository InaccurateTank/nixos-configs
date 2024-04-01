{
  config,
  lib,
  ...
}: let
  cfg = config.flakeMods.auto-upgrade;
in {
  options.flakeMods.auto-upgrade = {
    enable = lib.mkEnableOption "flake automatic upgrade preset";

    reboot = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable automatic reboots vs simply switching";
    };
  };

  config = lib.mkIf cfg.enable {
    system = {
      autoUpgrade = {
        enable = true;
        operation = lib.mkIf (! cfg.reboot) "switch";
        allowReboot = cfg.reboot;
        dates = "03:00";
        flake = "github:InaccurateTank/nixos-configs";
      };
    };
  };
}
