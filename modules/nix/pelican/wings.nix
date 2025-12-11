{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) types;
  inherit (lib) mkOption mkEnableOption mkPackageOption;
  inherit (lib.lists) optional;
  inherit (lib.modules) mkIf;

  cfg = config.flakeMods.pelican.wings;
  # user = cfg.user;
  # group = cfg.group;
in {
  options.flakeMods.pelican.wings = {
    enable = mkEnableOption "Pelican Wings service";
    package = mkPackageOption pkgs.flakePkgs "pelican-wings" {};

    # user = mkOption {
    #   description = ''
    #     The user Pelican Wings should run under.

    #     ::: {.note}
    #     If left as the default value this user will automatically be created
    #     on system activation, otherwise you are responsible for
    #     ensuring the user exists before the application starts.
    #     :::
    #   '';
    #   type = types.str;
    #   default = "pelican-wings";
    # };

    # group = mkOption {
    #   description = ''
    #     The group Pelican Wings should run under.

    #     ::: {.note}
    #     If left as the default value this group will automatically be created
    #     on system activation, otherwise you are responsible for
    #     ensuring the group exists before the application starts.
    #     :::
    #   '';
    #   type = types.str;
    #   default = "pelican-wings";
    # };

    configFile = mkOption {
      description = "Configuration yml file like ones generated from the panel.";
      type = types.path;
      default = "/etc/pelican/config.yml";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    # Wings creates its own user for some godamn reason
    users.users.pelican = {
      group = "pelican";
      isSystemUser = true;
      extraGroups = [ "docker" ];
    };
    users.groups.pelican = { };

    # users.users.pelican-wings = mkIf (user == "pelican-wings") {
    #   inherit group;
    #   isSystemUser = true;
    #   extraGroups = [ "podman" ];
    # };
    # users.groups.pelican-wings = mkIf (group == "pelican-wings") { };

    systemd.services.pelican-wings = {
      description = "Pelican Wings daemon";
      after = [ "docker.service" ];
      requires = [ "docker.service" ];
      partOf = [ "docker.service" ];
      wantedBy = [ "multi-user.target" ];
      # preStart = ''
      #   mkdir -p /var/log/pelican
      # '';
      serviceConfig = {
        Type = "simple";
        User = "pelican";
        Group = "pelican";
        Restart = "on-failure";
        WorkingDirectory = "/var/lib/pelican/wings";
        LogsDirectory = "pelican";
        ConfigurationDirectory = "pelican";
        StateDirectory =  "pelican/wings";
        ExecStart = "${cfg.package}/bin/wings --config ${cfg.configFile}";
        LimitNOFILE = 4096;
        PIDFile = "/run/wings/daemon.pid";
        RestartSec = 5;
        UMask = "077";
      };
      unitConfig = {
        StartLimitIntervalSec = 180;
        StartLimitBurst = 30;
      };
    };

    # I'd prefer podman but pelican isn't set up for that.
    virtualisation.docker.enable = true;
  };
}

