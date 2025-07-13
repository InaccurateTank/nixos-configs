{
  lib,
  inputs,
  self,
}: let
  internal = import ./internal.nix {inherit lib inputs self;};

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

  # System builder
  mkSystem = hostname: {
    system,
    users,
    wsl ? false,
    extraModules ? [],
    unfree ? [],
  }: let
    userImports = builtins.map (x: let
      split = lib.strings.splitString "." x;
    in
      self + "/users/${lib.strings.concatStringsSep "/" split}${lib.strings.optionalString (builtins.length split > 1) ".nix"}")
    users;
  in
    lib.nixosSystem {
      system = system;
      specialArgs = {
        inherit inputs;
        flakeLib = internal;
      };
      modules =
        [
          inputs.lix-module.nixosModules.default
          inputs.home-manager.nixosModules.home-manager
          {
            networking.hostName = hostname;
            home-manager = {
              useUserPackages = true;
              useGlobalPkgs = true;
              extraSpecialArgs = {inherit inputs;};
              sharedModules = allModulesIn (self + /modules/home);
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
              ];
            };
            nix.settings.experimental-features = ["nix-command" "flakes"];
          }
          # (self + "/modules/nix")
          (self + "/hosts/${hostname}")
        ]
        ++ allModulesIn (self + /modules/nix)
        ++ lib.optionals wsl [
          inputs.nixos-wsl.nixosModules.wsl
          {flakeMods.security.apparmor.enable = lib.mkForce false;}
        ]
        ++ userImports
        ++ extraModules;
    };
in {
  loadSystems = builtins.mapAttrs (name: value: (mkSystem name value));
}
