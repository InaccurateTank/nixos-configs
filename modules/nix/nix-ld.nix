{
  inputs,
  pkgs,
  ...
}: let
  nix-ld-rs = inputs.nix-ld-rs.packages.${pkgs.system}.default;
in {
  programs.nix-ld = {
    enable = true;
    package = nix-ld-rs;
  };
}
