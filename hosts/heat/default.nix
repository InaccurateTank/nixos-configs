{
  inputs,
  pkgs,
  ...
}: {
  flakePresets.vscode-remote-fix.enable = true;

  wsl = {
    enable = true;
    defaultUser = "inacct";
  };

  programs.zsh.enable = true;

  system.stateVersion = "23.11";
}
