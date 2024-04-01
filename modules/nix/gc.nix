{
  config,
  lib,
  ...
}: let
  cfg = config.flakeMods.gc;
in {
  options.flakeMods.gc.enable =
    lib.mkEnableOption "flake garbage collecting preset"
    // {default = true;};

  config = lib.mkIf cfg.enable {
    nix = {
      # Garbage Collecting
      # nix-store --optimize
      settings.auto-optimise-store = true;
      # nix-store --gc
      optimise.automatic = true;
      # nix-collect-garbage -d
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 14d";
      };
    };
  };
}
