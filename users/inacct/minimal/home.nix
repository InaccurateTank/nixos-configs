{
  lib,
  pkgs,
  ...
}: {
  home = {
    username = "inacct";
    homeDirectory = "/home/inacct";
    stateVersion = "23.11";
    shellAliases = {
      blahaj = "${pkgs.flakePkgs.display3d}/bin/display3d ${pkgs.flakePkgs.display3d}/share/resources/blahaj.obj";
    };
  };

  programs = {
    zsh = {
      enable = true;
      autosuggestion.enable = true;
      initExtra = ''
        bindkey "^[[1;5C" forward-word
        bindkey "^[[1;5D" backward-word

        function directory-title() {
          # Terminal Name
          print -nP '%{\033]0;%}%n@%m: %~%{\007\\%}'
          # OSC 7
          print -nP '%{\033]7;%}file://%m%d%{\033\\%}'
        }

        add-zsh-hook precmd directory-title
      '';
    };
    git = {
      enable = true;
      userName = "InaccurateTank";
      userEmail = "inaccuratetank@outlook.com";
    };
    thefuck.enable = true;
  };
}
