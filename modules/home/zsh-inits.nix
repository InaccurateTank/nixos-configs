{
  config,
  lib,
  ...
}: let
  cfg = config.flakeMods.zsh-inits;
in {
  options.flakeMods.zsh-inits = {
    arrowFix = lib.mkEnableOption "ctrl-arrow key fix.";
    oscSequences = lib.mkEnableOption "directory and window title operating system commands.";
  };

  config = let
    inits =
      lib.optional cfg.arrowFix ''
        bindkey "^[[1;5C" forward-word
        bindkey "^[[1;5D" backward-word
      ''
      ++ lib.optional cfg.oscSequences ''
        function directory-title() {
          # OSC 0
          print -nP '%{\033]0;%}%n@%m: %~%{\007\\%}'
          # OSC 7
          print -nP '%{\033]7;%}file://%m%d%{\033\\%}'
        }

        add-zsh-hook precmd directory-title
      '';
    initsString = builtins.concatStringsSep "\n" inits;
  in {
    programs.zsh.initContent = lib.mkAfter initsString;
  };
}
