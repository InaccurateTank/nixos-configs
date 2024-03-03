{
  description = "Tonks NixOS system configs";

  inputs = {
    # Packages
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Core
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

    # WM
    ags = {
      url = "github:Aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland";
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
    nixpkgs-unstable,
    home-manager,
    alejandra,
    ...
  } @ inputs: let
    # System builder
    mkSystem = architecture: hostname: extraModules:
      nixpkgs.lib.nixosSystem {
        system = architecture;
        specialArgs = {inherit inputs;};
        modules =
          [
            # home-manager installed by default
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
                    unstable = import nixpkgs-unstable {
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

    # Home Builder
    # mkHome = architecture: home:
    #   home-manager.lib.homeManagerConfiguration {
    #     pkgs = nixpkgs.legacyPackages.${architecture};
    #     extraSpecialArgs = {inherit inputs;};
    #     modules = [home];
    #   };
  in {
    nixosConfigurations = {
      # WSL
      "heat" = mkSystem "x86_64-linux" "heat" [
        ./modules/nix/nix-ld.nix
        ./users/inacct-wsl
      ];
      # VM
      "beehive" = mkSystem "x86_64-linux" "beehive" [
        ./modules/nix/nix-ld.nix
        ./users/control
      ];
      # Desktop
      "sabot" = mkSystem "x86_64-linux" "sabot" [
        ./users/inacct
      ];
    };

    # homeConfigurations = {
    #   "inacct@heat" = mkHome "x86_64-linux" ./users/inacct-wsl/home.nix;
    #   "inacct@sabot" = mkHome "x86_64-linux" ./users/inacct/home.nix;
    # };

    # nix fmt formatters
    formatter.x86_64-linux = alejandra.defaultPackage.x86_64-linux;
  };
}
