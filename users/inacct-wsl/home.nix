{...}: {
  home = {
    username = "inacct";
    homeDirectory = "/home/inacct";
    stateVersion = "23.11";
  };

  programs = {
    zsh = {
      enable = true;
      autosuggestion.enable = true;
      initExtra = ''
        bindkey "^[[1;5C" forward-word
        bindkey "^[[1;5D" backward-word

        function precmd() {
          # Terminal Name
          print -nP '%{\033]0;%}%n@%m: %~%{\007\\%}'
          # OSC 7
          print -nP '%{\033]7;%}file://%m%d%{\033\\%}'
        }

        PROMPT=$'%(!.%F{magenta}.%F{cyan})%~%f %(?.%F{green}.%F{red})❯%f '
        RPROMPT=$'%F{magenta}%n@%m%f'
      '';
    };
  };
}
