{
  inputs,
  config,
  ...
}: {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];
  home = {
    username = "control";
    homeDirectory = "/home/control";
    stateVersion = "25.05";
  };

  sops = {
    age.keyFile = "/home/control/.config/sops/age/keys.txt";
    secrets = {
      "gitEnv" = {
        format = "dotenv";
        sopsFile = "${inputs.secrets}/canister/control/git.env";
      };
    };
  };

  systemd.user.startServices = "sd-switch";

  flakeMods.quadlets = {
    mediaserver.enable = true;
    git = {
      enable = true;
      environmentFile = config.sops.secrets."gitEnv".path;
    };
  };

  virtualisation.quadlet.autoUpdate.enable = true;
}
