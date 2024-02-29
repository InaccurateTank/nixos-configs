{
  description = "Tonks NixOS system configs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    impermanence.url = "github:nix-community/impermanence";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-ld-rs = {
      url = "github:nix-community/nix-ld-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Formatter
    alejandra = {
      url = "github:kamadorueda/alejandra/3.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Custom
    pterodactyl = {
      url = "github:InaccurateTank/pterodactyl-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    crowdsec = {
      url = "github:InaccurateTank/crowdsec-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nix-ld-rs,
    home-manager,
    alejandra,
    ...
  } @ inputs: let
    # System builder
    mkSystem = architecture: hostname: extraModules:
      nixpkgs.lib.nixosSystem {
        system = architecture;
        modules =
          [
            home-manager.nixosModules.home-manager
            ./modules/security.nix
            (import ./hosts/${hostname} inputs)

            ({config, ...}: {
              networking.hostName = hostname;

              programs.nix-ld.package = nix-ld-rs.packages.${architecture}.default;

              home-manager = {
                useUserPackages = true;
                useGlobalPkgs = true;
              };
            })
          ]
          ++ extraModules;
      };

    # Home Builder
    mkHome = architecture: home:
      home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${architecture};
        modules = [home];
      };
  in {
    nixosConfigurations = {
      # WSL
      "heat" = mkSystem "x86_64-linux" "heat" [
        ./users/inaccuratetank
      ];
      # VM
      "beehive" = mkSystem "x86_64-linux" "beehive" [
        ./users/control
      ];
    };

    #Probably not useful but whatever
    homeConfigurations = {
      "inaccuratetank" = mkHome "x86_64-linux" ./users/inaccuratetank/home;
    };

    # nix fmt formatters
    formatter.x86_64-linux = alejandra.defaultPackage.x86_64-linux;
  };
}
