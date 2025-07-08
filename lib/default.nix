{
  lib,
  inputs,
  self,
}: let
  internal = import ./internal.nix {inherit lib inputs self;};
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
      "${self}/users/${lib.strings.concatStringsSep "/" split}${lib.strings.optionalString (builtins.length split > 1) ".nix"}")
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
              sharedModules = ["${self}/modules/home"];
            };
            nixpkgs = {
              config.allowUnfreePredicate = lib.mkIf (unfree != []) (pkg:
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
          "${self}/modules/nix"
          "${self}/hosts/${hostname}"
        ]
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
