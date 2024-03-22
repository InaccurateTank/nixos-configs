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
    alejandra,
    ...
  } @ inputs: let
    flakeLib = import ./lib.nix {
      inherit (nixpkgs) lib;
      inherit inputs;
    };
  in {
    # Formatter for nix fmt
    formatter = flakeLib.forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    # Packages exposed externally for easy build debugging
    packages = flakeLib.forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});

    # Actual NixOs configs
    nixosConfigurations = with flakeLib; {
      # WSL
      "heat" = mkSystem {
        hostname = "heat";
        wsl = true;
        users = [
          "inacct-wsl"
        ];
      };
      # VM
      "beehive" = mkSystem {
        hostname = "beehive";
        users = [
          "control"
        ];
      };
      # Desktop
      "sabot" = mkSystem {
        hostname = "sabot";
        users = [
          "inacct"
        ];
      };
    };
  };
}
