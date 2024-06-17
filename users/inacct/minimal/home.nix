{
  lib,
  pkgs,
  inputs,
  ...
}: {
  home = {
    username = "inacct";
    homeDirectory = "/home/inacct";
    stateVersion = "23.11";
    shellAliases = {
      blahaj = "${pkgs.flakePkgs.display3d}/bin/display3d ${pkgs.flakePkgs.display3d}/share/resources/blahaj.obj";
    };
    packages = with pkgs; [
      ouch
    ];
  };

  programs = {
    starship.enable = true;
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
    yazi = {
      enable = true;
      package = inputs.yazi.packages.${pkgs.system}.yazi;
      settings = {
        plugin = {
          prepend_previewers = [
            {
              mime = "application/*zip";
              run = "ouch";
            }
            {
              mime = "application/x-tar";
              run = "ouch";
            }
            {
              mime = "application/x-bzip2";
              run = "ouch";
            }
            {
              mime = "application/x-7z-compressed";
              run = "ouch";
            }
            {
              mime = "application/x-rar";
              run = "ouch";
            }
            {
              mime = "application/x-xz";
              run = "ouch";
            }
          ];
        };
      };
      plugins = {
        "starship.yazi" = inputs.starship-yazi;
        "ouch.yazi" = inputs.ouch-yazi;
      };
      initLua = ./yazi.lua;
    };
  };
}
