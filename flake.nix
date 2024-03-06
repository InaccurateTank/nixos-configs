{
  description = "Tonks NixOS system configs";

  inputs = {
    # Packages
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-23.11";

    # Core
    impermanence.url = "github:nix-community/impermanence";
    home-manager = {
      url = "github:nix-community/home-manager";
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

    # WM
    ags = {
      url = "github:Aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland/v0.36.0";
    hypridle = {
      url = "github:hyprwm/hypridle";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprlock = {
      url = "github:hyprwm/hyprlock";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Programs
    nix-software-center = {
      url = "github:snowfallorg/nix-software-center";
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
    nixpkgs-stable,
    home-manager,
    alejandra,
    ...
  } @ inputs: let
    # System builder
    mkSystem = {
      system ? "x86_64-linux",
      hostname ? "nixos",
      extraModules ? [],
    }:
      nixpkgs.lib.nixosSystem {
        system = system;
        specialArgs = {inherit inputs;};
        modules =
          [
            home-manager.nixosModules.home-manager
            {
              networking.hostName = hostname;
              home-manager = {
                useUserPackages = true;
                useGlobalPkgs = true;
                extraSpecialArgs = {inherit inputs;};
              };
              nixpkgs = {
                overlays = [
                  (final: prev: {
                    stable = import nixpkgs-stable {
                      system = prev.system;
                    };
                  })
                ];
              };
            }
            ./hosts/${hostname}
            ./modules/nix/security.nix
          ]
          ++ extraModules;
      };
  in {
    nixosConfigurations = {
      # WSL
      "heat" = mkSystem {
        hostname = "heat";
        extraModules = [
          ./modules/nix/nix-ld.nix
          ./users/inacct-wsl
        ];
      };
      # VM
      "beehive" = mkSystem {
        hostname = "beehive";
        extraModules = [
          ./modules/nix/nix-ld.nix
          ./users/control
        ];
      };
      # Desktop
      "sabot" = mkSystem {
        hostname = "sabot";
        extraModules = [
          ./modules/nix/hyprland.nix
          ./users/inacct
        ];
      };
    };

    # nix fmt formatters
    formatter.x86_64-linux = alejandra.defaultPackage.x86_64-linux;
  };
}
