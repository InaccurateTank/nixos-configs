{...}: {
  home = {
    username = "control";
    homeDirectory = "/home/control";
    stateVersion = "25.11";
  };

  flakeMods.zsh-inits = {
    arrowFix = true;
    oscSequences = true;
  };

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
  };
}
