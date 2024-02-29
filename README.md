# nix-config
minimal nix + i3 using only configuration.nix and dots


## base install w/no desktop or minimal 
-- in sudo or su
` nix-channel --remove nixos`
`nix-channel --add https://nixos.org/channels/nixos-unstable nixos`
`nix-channel --update`
`nixos-rebuild switch -upgrade`

then copy config and dots 
