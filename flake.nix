{
  description = "Tonks NixOS system configs";

  inputs = {
    ###### Core ######
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
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
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ###### Hyprland Stuff ######
    ags = {
      url = "github:Aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland";
    # hyprland.inputs.nixpkgs.follows = "nixpkgs";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    hy3 = {
      url = "github:outfoxxed/hy3";
      inputs.hyprland.follows = "hyprland";
    };
    hypridle = {
      url = "github:hyprwm/hypridle";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprlock = {
      url = "github:hyprwm/hyprlock";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ###### Other Flakes ######
    nix-flatpak.url = "github:gmodena/nix-flatpak/v0.3.0";
    firefox-gnome-theme = {
      url = "github:rafaelmardojai/firefox-gnome-theme";
      flake = false;
    };
    kvlibadwaita = {
      url = "github:GabePoel/KvLibadwaita";
      flake = false;
    };

    ###### Formatter ######
    alejandra = {
      url = "github:kamadorueda/alejandra/3.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ###### Personal ######
    secrets = {
      url = "git+ssh://git@git.inaccuratetank.gay/inaccuratetank/nix-secrets.git?ref=main&shallow=1";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    alejandra,
    ...
  } @ inputs: let
    systems = [
      "aarch64-linux"
      "i686-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    forAllSystems = nixpkgs.lib.genAttrs systems;

    flakeRoot = ./.;

    flakeLib = import ./lib.nix {
      inherit (nixpkgs) lib;
      inherit inputs flakeRoot;
    };
  in {
    # Formatter for nix fmt
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    # Packages exposed externally for easy build debugging
    packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});

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
