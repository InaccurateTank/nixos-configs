{
  config,
  lib,
  ...
}: let
  cfg = config.flakeMods.gc;
in {
  options.flakeMods.gc.enable =
    lib.mkEnableOption "flake home garbage collecting preset"
    // {default = true;};

  config = lib.mkIf cfg.enable {
    nix = {
      # nix-collect-garbage -d
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 14d";
      };
    };
  };
}
