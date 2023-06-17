{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    hyprland.url = "github:hyprwm/Hyprland";
    flake-utils.url = "github:numtide/flake-utils";
    unix-chad-bookmarks.url = "github:ElSargo/unix-chad-bookmarks";
    new-terminal-hyprland.url = "github:ElSargo/new-terminal-hyprland";
    grub-themes.url = "github:vinceliuice/grub2-themes";
    hyprpicker.url = "github:hyprwm/hyprpicker";
    nuscripts = {
      url = "github:nushell/nu_scripts";
      flake = false;
    };
    home-manager = {
      url =
        "github:nix-community/home-manager/6142193635ecdafb9a231bd7d1880b9b7b210d19";
      flake = false;
    };
    hosts = {
      url = "github:StevenBlack/hosts";
      flake = false;
    };
  };

  outputs =
    { self, nixpkgs, nixpkgs-unstable, flake-utils, hyprpicker, grub-themes, ... }@attrs:

    let
      system = "x86_64-linux";
      unstable-overlay = final: prev: {
        unstable = import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };
      };
      unstable-module = ({ config, pkgs, ... }: {
        nixpkgs.overlays = [ unstable-overlay hyprpicker.overlays.default ];
      });
      specialArgs = attrs // { inherit system; theme = "stylish"; };
    in {
      formatter.${system} = (import nixpkgs-unstable { inherit system; }).nil;
      nixosConfigurations = {

        SargoSummit = nixpkgs.lib.nixosSystem {
          inherit system specialArgs;
          modules = [ unstable-module grub-themes.nixosModules.default ./configuration.nix ./summit.nix ];
        };

        SargoLaptop = nixpkgs.lib.nixosSystem {
          inherit system specialArgs;
          modules = [ unstable-module ./configuration.nix ./laptop.nix ];
        };

      };
    };
}
