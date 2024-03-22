{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: let
  cfg = config.flakePresets.nix-ld;
in {
  options.flakePresets.nix-ld.enable = lib.mkEnableOption "flake nix-ld preset";

  config = lib.mkIf cfg.enable {
    programs.nix-ld = {
      enable = true;
      package = inputs.nix-ld-rs.packages.${pkgs.system}.default;
    };
  };
}
