# Flake Global Modules

Nix(OS):
|Module|Purpose|Default Enabled?|
|---|---|:-:|
|pelican|Experimental module for the Pelican game server management tool|:x:|
|auto-upgrade|Enables automatic updates (using the repo flake.lock)|:x:|
|gc|Nix store garbage collection and optimization|:heavy_check_mark:|
|hyprland|Hyprland WM base setup|:x:|
|impermanence|Minimum viable impermanence setup with optional BTRFS integration|:x:|
|secrets|Usage of the sops-nix secrets pipeline|:x:|
|security|Some defaults for system hardening|:heavy_check_mark:|
|shell-prompt.nix|Starship prompt|:x:|
|vscode-remote-fix|Fixes VsCode not being able to remote connect to NixOS|:x:|

Home(-Manager):
|Module|Purpose|Default Enabled?|
|---|---|:-:|
|quadlets|Predefined podman quadlets for use with [quadlet-nix](https://github.com/SEIAROTg/quadlet-nix)|:x:|
|gc|Nix store garbage collection|:heavy_check_mark:|
|swww|Sets up the swww wallpaper daemon|:x:|
|zsh-inits|Applies some minor QOL for zsh|:x:|
