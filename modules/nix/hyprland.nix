{
  inputs,
  pkgs,
  ...
}: {
  # Override with nixos-unstable
  disabledModules = [
    "programs/hyprland.nix"
  ];
  imports = [
    "${inputs.nixpkgs-unstable}/nixos/modules/programs/wayland/hyprland.nix"
  ];

  programs = {
    hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.default;
      xwayland.enable = true;
    };
  };
}
