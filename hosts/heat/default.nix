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
    # Needed for working vscode for some reason?
    extraBin = with pkgs; [
      {src = "${coreutils}/bin/uname";}
      {src = "${coreutils}/bin/dirname";}
      {src = "${coreutils}/bin/readlink";}
      {src = "${coreutils}/bin/cat";}
      {src = "${gnused}/bin/sed";}
    ];
  };

  environment.systemPackages = with pkgs; [
    wget
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];

  system.stateVersion = "23.11";
}
