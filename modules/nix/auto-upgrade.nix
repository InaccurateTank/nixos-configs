{
  config,
  lib,
  ...
}: let
  cfg = config.flakePresets.auto-upgrade;
in {
  options.flakePresets.auto-upgrade = {
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
        operation = mkIf (! cfg.reboot) "switch";
        enable = true;
        allowReboot = cfg.reboot;
        dates = "03:00";
        flake = "github:InaccurateTank/nixos-configs";
      };
    };
  };
}
