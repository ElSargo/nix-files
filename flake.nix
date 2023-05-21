{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    hyprland.url = "github:hyprwm/Hyprland";
    flake-utils.url = "github:numtide/flake-utils";
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

  outputs = { self, nixpkgs, nixpkgs-unstable, flake-utils, ... }@attrs:
    # flake-utils.lib.eachDefaultSystem (system:
    let
      system = "x86_64-linux";
      overlay-unstable = final: prev: {
        unstable = import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };
      };
    in {
      # replace 'joes-desktop' with your hostname here.
      nixosConfigurations.SargoSummit = nixpkgs.lib.nixosSystem {
        specialArgs = attrs ;
        inherit system;
        modules = [
          ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-unstable ]; })
          ./configuration.nix
          ./summit.nix
        ];
      };
      nixosConfigurations.SargoLaptop = nixpkgs.lib.nixosSystem {
        specialArgs = attrs;
        inherit system;
        modules = [
          ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-unstable ]; })
          ./configuration.nix
          ./laptop.nix
        ];
      };
    };
}
