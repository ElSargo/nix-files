{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.11";
    unstable.url = "nixpkgs/nixos-unstable";
    home-manager.url = "https://github.com/nix-community/home-manager";
    flake-compat.url = "https://github.com/edolstra/flake-compat";
    nuscripts.url = "https://github.com/nushell/nu_scripts/";
    hosts.url = "https://github.com/StevenBlack/hosts/";
    hyprland.url = "https://github.com/hyprwm/Hyprland";

  };

  outputs = inputs@{ self, nixpkgs, unstable, home-manager, flake-compat
    , nuscripts, hosts, hyprland }:
    let system = "x86_64-linux";
    in {
      nixosConfigurations = {
        SargoSummit = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [ ./configuration.nix ];
        };
      };
    };
}
