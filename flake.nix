{
  inputs = {

    nixpkgs.url = "nixpkgs/nixos-23.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";

    home-manager.url = "github:nix-community/home-manager/release-23.05";
    hyprland.url = "github:hyprwm/Hyprland";
    flake-utils.url = "github:numtide/flake-utils";
    helix-flake.url = "github:the-mikedavis/helix";
    nuscripts.url = "github:nushell/nu_scripts";

    unix-chad-bookmarks.url = "github:ElSargo/unix-chad-bookmarks";
    supabar.url = "github:ElSargo/supabar";
    eww-bar.url = "github:ElSargo/eww-bar";
    new-terminal-hyprland.url = "github:ElSargo/new-terminal-hyprland";
    nvim.url = "github:ElSargo/nvim";
    wgsl.url = "github:ElSargo/wgsl-analyzer";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, flake-utils, eww-bar, nur
    , home-manager, helix-flake, ... }@attrs:
    flake-utils.lib.eachDefaultSystem (system:

      let
        unstable-overlay = final: prev: {
          unstable = import nixpkgs-unstable {
            inherit system;
            config.allowUnfree = true;
          };
        };
        helix = helix-flake.packages.${system}.default;
        overlays = ({ config, pkgs, ... }: {
          nixpkgs.overlays =
            [ unstable-overlay eww-bar.overlays.${system}.default ];
        });
        specialArgs = attrs // { inherit system helix; };
        default_modules = [
          overlays
          nur.nixosModules.nur
          ./nixos/configuration.nix
          ./users/sargo.nix
        ];
      in {
        packages = {
          formatter.${system} =
            (import nixpkgs-unstable { inherit system; }).nil;
          nixosConfigurations = {

            SargoSummit = nixpkgs.lib.nixosSystem {
              inherit system specialArgs;
              modules = default_modules ++ [ ./hosts/summit.nix ];
            };

            SargoLaptop = nixpkgs.lib.nixosSystem {
              inherit specialArgs;
              modules = default_modules ++ [ ./hosts/laptop.nix ];
            };

          };

        };
        devShells = {
          default = let pkgs = nixpkgs.legacyPackages.${system};
          in pkgs.mkShell {
            NIX_CONFIG = "experimental-features = nix-command flakes";
            nativeBuildInputs = with pkgs; [
              nix
              git
              nil
              helix
              wget
              ripgrep
              zellij
            ];
          };
        };
      });
}
