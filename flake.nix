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
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.93.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ###### Hyprland Stuff ######
    ags = {
      url = "github:aylur/ags/v1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    # hyprland.inputs.nixpkgs.follows = "nixpkgs";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    hy3 = {
      url = "github:outfoxxed/hy3";
      inputs.hyprland.follows = "hyprland";
    };

    ###### Other Flakes ######
    # nix-flatpak.url = "github:gmodena/nix-flatpak/v0.4.1";
    starship-yazi = {
      url = "github:Rolv-Apneseth/starship.yazi";
      flake = false;
    };
    ouch-yazi = {
      url = "github:ndtoan96/ouch.yazi";
      flake = false;
    };
    firefox-gnome-theme = {
      url = "github:rafaelmardojai/firefox-gnome-theme";
      flake = false;
    };
    kvlibadwaita = {
      url = "github:GabePoel/KvLibadwaita";
      flake = false;
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
    ...
  } @ inputs: let
    systems = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    forAllSystems = nixpkgs.lib.genAttrs systems;

    flakeLib = import ./lib.nix {
      inherit (nixpkgs) lib;
      inherit inputs self;
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
          "inacct"
        ];
      };
      # Media Server VM
      "canister" = mkSystem {
        hostname = "canister";
        users = [
          "control"
        ];
      };
      # Desktop
      "sabot" = mkSystem {
        hostname = "sabot";
        userProfile = "full";
        users = [
          "inacct"
        ];
      };
    };
  };
}
