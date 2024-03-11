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
    nixpkgs-stable,
    home-manager,
    alejandra,
    ...
  } @ inputs: let
    # All Possible Systems
    systems = [
      "aarch64-linux"
      "i686-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];

    forAllSystems = nixpkgs.lib.genAttrs systems;

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
            ({lib, ...}: {
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
                  # Nixpkgs Stable import
                  (final: prev: {
                    stable = import nixpkgs-stable {
                      system = prev.system;
                    };
                  })

                  # Flake packages added as overlay
                  (final: prev: {
                    flakePkgs = import ./pkgs prev;
                  })
                ];
              };
            })
            ./hosts/${hostname}
            ./modules/nix/security.nix
          ]
          ++ extraModules;
      };
  in {
    # Formatter for nix fmt
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    # Packages exposed externally for easy build debugging
    packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});

    # Actual NixOs configs
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
  };
}
