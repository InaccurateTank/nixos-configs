{
  nixos-wsl,
  vscode-server,
  ...
}: {
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    nixos-wsl.nixosModules.wsl
    vscode-server.nixosModules.default
  ];

  wsl = {
    enable = true;
    defaultUser = "inaccuratetank";
    extraBin = with pkgs; [
      {src = "${coreutils}/bin/uname";}
      {src = "${coreutils}/bin/dirname";}
      {src = "${coreutils}/bin/readlink";}
      {src = "${coreutils}/bin/cat";}
      {src = "${gnused}/bin/sed";}
    ];
  };

  programs.nix-ld.enable = true;
  services.vscode-server.enable = true;

  environment.systemPackages = with pkgs; [
    wget
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];

  system.stateVersion = "23.11";
}
