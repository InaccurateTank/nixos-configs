{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.nixos-wsl.nixosModules.wsl
  ];

  wsl = {
    enable = true;
    defaultUser = "inacct";
  };

  programs.zsh.enable = true;

  system.stateVersion = "23.11";
}
