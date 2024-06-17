{
  lib,
  inputs,
  self,
}: {
  # Simple path fetcher for the externally stored secrets
  fetchSecret = path: "${inputs.secrets}/${path}";

  # Simple fetcher for user public keys for ssh
  fetchPubKeys = keys: lib.map (k: "${self}/users/keys/${k}.pub") keys;

  # System builder
  mkSystem = {
    system ? "x86_64-linux",
    hostname ? "nixos",
    wsl ? false,
    users,
    userProfile ? "",
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
              sharedModules = [./modules/home];
            };
            nixpkgs = {
              config.allowUnfreePredicate = pkg:
                builtins.elem (lib.getName pkg) [
                  "vscode"
                  "steam"
                  "steam-original"
                  "steam-run"
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
          {flakeMods.security.apparmor.enable = false;}
        ]
        ++ builtins.map (x:
          ./users/${x} + lib.optionalString (!wsl && userProfile != "") "/${userProfile}")
        users
        ++ extraModules;
    };
}
