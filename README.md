# nixos-configs
Because copying the configs through ssh officially is too much work now

|Host|Purpose|
|---|---|
|[canister](./hosts/canister)|Mediaserver VM|
|[heat](./hosts/heat)|Personal WSL instance|
|[sabot](./hosts/sabot)|Personal desktop dual booted with Windows|

## Known Issues
- Microphones refuse to switch for some reason
- App mixer seems to only really work up to 80%?
- AGS takes yonks to recover after a sleep
- Hotkeys are jank...
- Fresh build seems to OOM if there are more cores than GB of RAM. Mostly from the font building.
- Plymouth seems to be acting... janky?

## Todo
- Persist more data (Mostly firefox, discord, vscode)
- Add a clipboard
- Get steam working
- Shuffle some folders around
