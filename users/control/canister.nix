{...}: {
  imports = [
    ./default.nix
  ];

  home-manager.users.control = {inputs, ...}: {
    imports = [
      inputs.quadlet-nix.homeManagerModules.quadlet
    ];

    home = {
      username = "control";
      homeDirectory = "/home/control";
      stateVersion = "25.05";
    };
  };
}
