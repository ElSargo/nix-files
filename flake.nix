{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
    hyprland.url = "github:hyprwm/Hyprland";
    flake-utils.url = "github:numtide/flake-utils";
    unix-chad-bookmarks.url = "github:ElSargo/unix-chad-bookmarks";
    supabar.url = "github:ElSargo/supabar";
    eww-bar.url = "github:ElSargo/eww-bar";
    helix.url = "github:the-mikedavis/helix";
    new-terminal-hyprland.url = "github:ElSargo/new-terminal-hyprland";
    nvim.url = "github:ElSargo/nvim";
    nuscripts.url = "github:nushell/nu_scripts";
    home-manager.url = "github:nix-community/home-manager/release-23.05";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, flake-utils, eww-bar, nur
    , home-manager, ... }@attrs:
    with builtins;
    flake-utils.lib.eachDefaultSystem (system:

      let
        unstable-overlay = final: prev: {
          unstable = import nixpkgs-unstable {
            inherit system;
            config.allowUnfree = true;
          };
        };
        overlays = ({ config, pkgs, ... }: {
          nixpkgs.overlays =
            [ unstable-overlay eww-bar.overlays.${system}.default ];
        });
        specialArgs = attrs // { inherit system; };
        default_modules =
          [ overlays nur.nixosModules.nur ./configuration.nix ./sargo.nix ];
      in {
        packages = {
          formatter.${system} =
            (import nixpkgs-unstable { inherit system; }).nil;
          nixosConfigurations = {

            SargoSummit = nixpkgs.lib.nixosSystem {
              inherit system specialArgs;
              modules = concatLists [ default_modules [ ./summit.nix ] ];
            };

            SargoLaptop = nixpkgs.lib.nixosSystem {
              inherit system specialArgs;
              modules = concatLists [ default_modules [ ./laptop.nix ] ];
            };

          };
        };
      });
}
