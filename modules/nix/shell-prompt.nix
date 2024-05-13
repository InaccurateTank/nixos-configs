{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.flakeMods.shell-prompt;
in {
  options.flakeMods.shell-prompt.enable = lib.mkEnableOption "flake starship shell prompt preset";

  config = lib.mkIf cfg.enable {
    programs.starship = let
      lang = style: symbol: {
        format = "| [$symbol($version)](bold $style) ";
        inherit symbol style;
      };
    in {
      enable = true;
      settings = {
        format = lib.concatStrings [
          "$nix_shell"
          "$username"
          "$hostname"
          "$os"
          "$container"
          "$directory"
          "$git_branch"
          "$git_status"
          "$nodejs"
          "$lua"
          "$rust"
          "$cmd_duration"
          "$line_break"
          "$character"
        ];
        right_format = "$time";

        container = {
          format = "[[$symbol]($style)$name](bold $style) ";
          style = "cyan";
          symbol = " ";
        };

        cmd_duration = {
          format = "| [$duration]($style) ";
          style = "bold purple";
        };

        line_break.disabled = true;

        nix_shell = {
          format = "[$symbol$state( \\($name\\))]($style) ";
          symbol = "[](fg:cyan) ";
        };

        git_branch = {
          format = "| [$symbol[$branch](bold $style)]($style) ";
          symbol = " ";
          style = "bright-red";
        };

        git_status = {
          format = "[(\\[$conflicted$untracked$modified$staged$renamed$deleted\\])( $ahead_behind$stashed)]($style) ";
          style = "bold bright-red";
          stashed = "≡";
        };

        time = {
          disabled = false;
          style = "bold red dimmed";
          time_format = "%I:%M %p";
          format = "[\\[$time\\]]($style)";
        };

        directory.read_only = "";

        username = {
          format = "[$user]($style) ";
          style_user = "bold red";
        };

        hostname = {
          format = "[$ssh_symbol$hostname]($style) ";
          ssh_symbol = " ";
          style = "bold red";
        };

        nodejs = lang "green" " ";
        lua = lang "blue" " ";
        rust = lang "red" " ";

        os = {
          disabled = false;
          format = "[$symbol]($style) ";
        };

        os.symbols = {
          AlmaLinux = "[](fg:blue) ";
          Alpine = "[](fg:cyan) ";
          Arch = "[](fg:cyan) ";
          Debian = "[](fg:red) ";
          NixOS = "[](fg:cyan) ";
          openSUSE = "[](fg:bright-green) ";
          Pop = "[](fg:white) ";
          Raspbian = "[](fg:red) ";
          RockyLinux = "[](fg:green) ";
          Ubuntu = "[](fg:bright-red) ";
          Windows = "[](fg:cyan) ";
        };
      };
    };
  };
}
