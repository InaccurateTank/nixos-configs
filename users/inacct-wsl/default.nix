# {pkgs, ...}: {
#   users.users.inacct = {
#     isNormalUser = true;
#     shell = pkgs.zsh;
#     extraGroups = ["wheel"];
#   };

#   home-manager.users.inacct = ./home.nix;
# }
