{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.flakeMods.swww;
in {
  options.flakeMods.swww.enable = lib.mkEnableOption "swww desktop wallpaper daemon";

  config = lib.mkIf cfg.enable {
    # For invoking from command line
    home.packages = [pkgs.swww];

    # Basic systemd service
    systemd.user.services.swww = {
      Unit = {
        Description = "swww";
        After = ["graphical-session.target"];
      };

      Service = {
        ExecStart = "${pkgs.swww}/bin/swww-daemon";
        Restart = "always";
        RestartSec = "10";
      };

      Install.WantedBy = ["default.target"];
    };
  };
}
