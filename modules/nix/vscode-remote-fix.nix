{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.flakeMods.vscode-remote-fix;
in {
  options.flakeMods.vscode-remote-fix.enable = lib.mkEnableOption "flake vscode remote fixer preset";

  config = lib.mkIf cfg.enable {
    flakeMods.nix-ld.enable = true;

    environment.systemPackages = [pkgs.wget];

    system.activationScripts.vscodeFixUsers = with lib; let
      fixFile = pkgs.writeText "vscodeRemoteFix" ''
        PATH=$PATH:/run/current-system/sw/bin/
      '';
      realUsers = filterAttrs (_: v: v.isNormalUser && v.home != "/var/empty") config.users.users;
      cmdList = mapAttrsToList (_: v: "install -d -m 755 -o ${v.name} -g users ${v.home}/.vscode-server && ln -fs ${fixFile} ${v.home}/.vscode-server/server-env-setup") realUsers;
    in
      concatLines cmdList;
  };
}
