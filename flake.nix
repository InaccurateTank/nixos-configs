{
  description = "Tonks NixOS system configs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    impermanence.url = "github:nix-community/impermanence";
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pterodactyl = {
      url = "github:InaccurateTank/pterodactyl-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    crowdsec = {
      url = "github:InaccurateTank/crowdsec-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-wsl, ... }@inputs: {
    nixosConfigurations = {
        "heat" = nixpkgs.lib.nixosSystem {
          nixpkgs.hostPlatform = "x86_64-linux";
          modules = [
            nixos-wsl.nixosModules.wsl
            ./hosts/heat
          ];
        };
        "nixtest" = nixpkgs.lib.nixosSystem {
          modules = [
            (import ./hosts/nixtest inputs)
          ];
        };
    };
  };
}
