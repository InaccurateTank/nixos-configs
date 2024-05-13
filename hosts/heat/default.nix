{
  inputs,
  pkgs,
  ...
}: {
  flakeMods = {
    shell-prompt.enable = true;
    vscode-remote-fix.enable = true;
  };

  wsl = {
    enable = true;
    defaultUser = "inacct";
  };

  time = {
    timeZone = "America/Los_Angeles";
    hardwareClockInLocalTime = true;
  };

  programs.zsh.enable = true;

  system.stateVersion = "23.11";
}
