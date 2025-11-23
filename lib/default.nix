{
  lib,
  inputs,
  self,
}: let
  internal = import ./internal.nix {inherit lib inputs self;};

  # Recursively searches a folder for module files.
  allModulesIn = let
    searchFiles = path:
      builtins.mapAttrs
      (file: type:
        if type == "directory"
        then searchFiles "${path}/${file}"
        else type)
      (builtins.readDir path);
    files = path:
      lib.collect
      builtins.isString
      (lib.mapAttrsRecursive
        (file: type: lib.concatStringsSep "/" file)
        (searchFiles path));
  in
    path:
      builtins.map
      (file: path + "/${file}")
      (builtins.filter
        (file: lib.hasSuffix ".nix" file && file != "default.nix")
        (files path));

  # Gets all users in designated folder.
  userSearch = path:
    assert lib.assertMsg (builtins.pathExists path) "Users folder path ${path} does not exist"; (lib.mapAttrs'
      (file: type:
        lib.nameValuePair
        (lib.removeSuffix ".nix" file)
        {
          files =
            if type == "directory"
            then path + "/${file}/user.nix"
            else path + "/${file}";
          homeFiles =
            if type == "directory"
            then
              if builtins.pathExists (path + "/${file}/home.nix")
              then path + "/${file}/home.nix"
              else if builtins.pathExists (path + "/${file}/home/home.nix")
              then path + "/${file}/home/home.nix"
              else null
            else null;
        })
      (lib.filterAttrs
        (file: type:
          if type == "directory"
          then builtins.pathExists (path + "/${file}/user.nix")
          else lib.hasSuffix ".nix" file && file != "default.nix")
        (builtins.readDir path)));

  # System builder
  mkSystem = hostname: {
    system,
    # users,
    wsl ? false,
    extraModules ? [],
    unfree ? [],
  }: let
    # Host path in flake
    systemFolder = self + "/hosts/${hostname}";
    #  Get both per-system and common user configs
    systemUsers = let
      users = userSearch (systemFolder + "/users");
    in
      lib.zipAttrsWithNames
      (builtins.attrNames users)
      (name: values:
        lib.zipAttrsWith
        (name: values: builtins.filter (file: file != null) values)
        values)
      [
        users
        (userSearch (self + /users))
      ];
  in
    lib.nixosSystem {
      system = system;
      specialArgs = {
        inherit inputs;
        flakeLib = internal;
      };
      modules =
        [
          # inputs.lix-module.nixosModules.default
          inputs.home-manager.nixosModules.home-manager
          {
            networking.hostName = hostname;
            home-manager = {
              useUserPackages = true;
              useGlobalPkgs = true;
              extraSpecialArgs = {inherit inputs;};
              sharedModules = allModulesIn (self + /modules/home);
              users =
                builtins.mapAttrs (name: value: {
                  imports = value.homeFiles;
                })
                systemUsers;
            };
            nixpkgs = {
              config.allowUnfreePredicate =
                lib.mkIf (unfree != []) (pkg:
                  builtins.elem (lib.getName pkg) unfree);
              overlays = [
                # Flake packages added as overlay
                (final: prev: {
                  flakePkgs = import "${self}/pkgs" prev;
                })
                (final: prev: {
                  inherit
                    (final.lixPackageSets.stable)
                    nixpkgs-review
                    nix-direnv
                    nix-eval-jobs
                    nix-fast-build
                    colmena
                    ;
                })
              ];
            };
            nix.settings.experimental-features = ["nix-command" "flakes"];
            nix.package = inputs.nixpkgs.legacyPackages.${system}.lixPackageSets.stable.lix;
          }
          (systemFolder + "/configuration.nix")
        ]
        ++ allModulesIn (self + /modules/nix)
        ++ lib.optionals wsl [
          inputs.nixos-wsl.nixosModules.wsl
          {flakeMods.security.apparmor.enable = lib.mkForce false;}
        ]
        ++ lib.flatten (lib.mapAttrsToList (name: value: value.files) systemUsers)
        ++ extraModules;
    };
in {
  loadSystems = builtins.mapAttrs (name: value: (mkSystem name value));
}
