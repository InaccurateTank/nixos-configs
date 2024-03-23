{
  lib,
  inputs,
}: {
  # System builder
  mkSystem = {
    system ? "x86_64-linux",
    hostname ? "nixos",
    wsl ? false,
    users,
    extraModules ? [],
  }:
    lib.nixosSystem {
      system = system;
      specialArgs = {inherit inputs;};
      modules =
        [
          inputs.home-manager.nixosModules.home-manager
          {
            networking.hostName = hostname;
            home-manager = {
              useUserPackages = true;
              useGlobalPkgs = true;
              extraSpecialArgs = {inherit inputs;};
            };
            nixpkgs = {
              config.allowUnfreePredicate = pkg:
                builtins.elem (lib.getName pkg) [
                  "vscode"
                ];
              overlays = [
                # Flake packages added as overlay
                (final: prev: {
                  flakePkgs = import ./pkgs prev;
                })
              ];
            };
            nix.settings.experimental-features = ["nix-command" "flakes"];
          }
          ./modules/nix
          ./hosts/${hostname}
        ]
        ++ lib.optionals wsl [
          inputs.nixos-wsl.nixosModules.wsl
          {flakePresets.security.apparmor.enable = false;}
        ]
        ++ builtins.map (x: ./users/${x}) users
        ++ extraModules;
    };
}
