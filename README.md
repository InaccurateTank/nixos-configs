# nixos-configs
Because copying the configs through ssh officially is too much work now

|Host|Purpose|
|---|---|
|[canister](./hosts/canister)|Mediaserver VM|
|hesh|Pelican game server VM (Planned)|
|[heat](./hosts/heat)|Personal WSL instance|
|[sabot](./hosts/sabot)|Personal desktop dual booted with Windows|

## Directory Structire

- **hosts:** Configuration for each VM or physical device.
  - **users:** Per-system user configurations. Same structure as `/users`
  - **configuration.nix:** NixOS configuration file.
- **lib:** Tools for flake functioning.
- **modules:** Custom modules to be injected into configurations under the alias `flakeMods`.
  - **home:** Home-manager modules.
  - **nix:** NixOS modules.
- **pkgs:** Packages to be injected into configurations as an overlay under the alias `flakePkgs`
- **users:** Global user configuration. Folders here are only loaded if the per-system configuration contains the same user.
  - **\<user\>/user.nix:** Primary user configuration. Also works as `<user>.nix`.
  - **\<user\>/home/home.nix:** Home-manager configuration. Also works under `<user>/home.nix`.
