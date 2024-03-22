{
  description = "Tonks NixOS system configs";

  inputs = {
    # Packages
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

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
    hyprland.inputs.nixpkgs.follows = "nixpkgs";
    hypridle = {
      url = "github:hyprwm/hypridle";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprlock = {
      url = "github:hyprwm/hyprlock";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Other
    nix-flatpak.url = "github:gmodena/nix-flatpak/v0.3.0";
    firefox-gnome-theme = {
      url = "github:rafaelmardojai/firefox-gnome-theme";
      flake = false;
    };
    kvlibadwaita = {
      url = "github:GabePoel/KvLibadwaita";
      flake = false;
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
                  # Flake packages added as overlay
                  (final: prev: {
                    flakePkgs = import ./pkgs prev;
                  })
                ];
              };
              nix.settings.experimental-features = ["nix-command" "flakes"];
            })
            ./hosts/${hostname}
            ./modules/nix/security.nix
            ./modules/nix/gc.nix
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
          ./modules/nix/vscode-remote-fix.nix
          ./users/inacct-wsl
        ];
      };
      # VM
      "beehive" = mkSystem {
        hostname = "beehive";
        extraModules = [
          ./modules/nix/vscode-remote-fix.nix
          ./users/control
        ];
      };
      # Desktop
      "sabot" = mkSystem {
        hostname = "sabot";
        extraModules = [
          ./modules/nix/vscode-remote-fix.nix
          ./modules/nix/hyprland.nix
          ./users/inacct
        ];
      };
    };
  };
}
