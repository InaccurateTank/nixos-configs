{
  lib,
  config,
  ...
}: {
  imports = [
    ./nix-ld.nix
  ];

  environment.systemPackages = with pkgs; [
    wget
  ];

  system.activationScripts.userList = with lib; let
    fixFile = pkgs.writeText "vscodeRemoteFix" ''
      PATH=$PATH:/run/current-system/sw/bin/
    '';
    realUsers = filterAttrs (_: v: v.isNormalUser && v.home != "/var/empty") config.users.users;
    cmdList = mapAttrsToList (_: v: "mkdir -p ${v.home}/.vscode-server && ln -fs ${fixFile} ${v.home}/.vscode-server/server-env-setup") realUsers;
  in
    concatStringsSep "\n" cmdList;
}
