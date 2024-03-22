{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: let
  cfg = config.flakePresets.hyprland;
in {
  options.flakePresets.hyprland.enable = lib.mkEnableOption "flake Hyprland preset";

  config = lib.mkIf cfg.enable {
    nix.settings = {
      substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
    };

    environment.sessionVariables.NIXOS_OZONE_WL = "1";
    environment.sessionVariables.WLR_NO_HARDWARE_CURSORS = "1";

    programs = {
      hyprland = {
        enable = true;
        package = inputs.hyprland.packages.${pkgs.system}.hyprland;
        xwayland.enable = true;
      };
    };
  };
}
