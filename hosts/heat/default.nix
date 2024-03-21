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

  nix.settings.experimental-features = ["nix-command" "flakes"];

  system.stateVersion = "23.11";
}
