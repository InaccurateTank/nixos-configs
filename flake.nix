{
  description = "test flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    pterodactyl-wings.url = "github:InaccurateTank/pterodactyl-flake";
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations = {
        "nixtest" = nixpkgs.lib.nixosSystem {
            specialArgs = { inherit inputs; };
            modules = [ ./hosts/nixtest ];
        };
    };
  };
}
