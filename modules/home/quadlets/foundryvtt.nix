{
  config,
  lib,
  ...
}: let
  cfg = config.flakeMods.quadlets.foundryvtt;
in {
  options.flakeMods.quadlets.foundryvtt = {
    enable = lib.mkEnableOption "foundryvtt podman container";
  };

  config = lib.mkIf cfg.enable {
    virtualisation.quadlet = let
      inherit (config.virtualisation.quadlet) containers pods;
    in {
      containers = {
        foundryvtt = {
          containerConfig = {
            image = "docker-archive:${pkgs.flakePkgs.container-images.fvttNode}";
            volumes = [
              "/srv/containers/foundryvtt/pkg:/pkg:Z"
              "/srv/containers/foundryvtt/data:/data:Z"
            ];
          };
        };
      };
    };
  };
}
