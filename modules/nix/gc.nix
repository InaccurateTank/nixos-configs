{...}: {
  nix = {
    # Garbage Collecting
    # nix-store --optimize
    settings.auto-optimise-store = true;
    # nix-store --gc
    optimise.automatic = true;
    # nix-collect-garbage -d
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };
}
