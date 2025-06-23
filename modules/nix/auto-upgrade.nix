{
  config,
  lib,
  ...
}: let
  inherit (lib) types;
  inherit (lib) mkOption mkEnableOption;
  inherit (lib.lists) optional;
  inherit (lib.modules) mkIf;

  cfg = config.flakeMods.auto-upgrade;
in {
  options.flakeMods.auto-upgrade = {
    enable = mkEnableOption "flake automatic upgrade preset";

    reboot = mkOption {
      type = types.bool;
      default = false;
      description = "Enable automatic reboots vs simply switching";
    };

    maxJobs = mkOption {
      type = types.nullOr types.int;
      default = null;
      description = "Limit the number of parallel jobs done while building";
    };
  };

  config = mkIf cfg.enable {
    system = {
      autoUpgrade = {
        enable = true;
        operation = "switch";
        flags = optional (cfg.maxJobs != null) "--max-jobs ${toString cfg.maxJobs}";
        allowReboot = cfg.reboot;
        dates = "03:00";
        flake = "github:InaccurateTank/nixos-configs";
      };
    };
  };
}
