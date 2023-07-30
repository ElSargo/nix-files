{
  inputs = {

    nixpkgs.url = "nixpkgs/nixos-23.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";

    home-manager.url = "github:nix-community/home-manager/release-23.05";
    flake-utils.url = "github:numtide/flake-utils";
    nuscripts.url = "github:nushell/nu_scripts";
    firefox-gnome-theme = {
      url = "github:rafaelmardojai/firefox-gnome-theme";
      flake = false;
    };

    helix-flake = {
      url = "github:the-mikedavis/helix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    unix-chad-bookmarks = {
      url = "github:ElSargo/unix-chad-bookmarks";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    supabar = {
      url = "github:ElSargo/supabar";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvim = { url = "github:ElSargo/nvim"; };
    wgsl = {
      url = "github:ElSargo/wgsl-analyzer";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zellij-runner = {
      url = "github:ElSargo/zellij-runner";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, flake-utils, nur, home-manager
    , helix-flake, supabar, nvim, wgsl, zellij-runner, unix-chad-bookmarks, ...
    }@attrs:
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
          nixpkgs.overlays = [
            unstable-overlay
            unix-chad-bookmarks.overlays.${system}.default
            # supabar.overlays.${system}.default
            nvim.overlays.${system}.default
            wgsl.overlays.${system}.default
            zellij-runner.overlays.${system}.default
          ];
        });
        specialArgs = attrs // { inherit system helix; };
        default_modules = [
          overlays
          nur.nixosModules.nur
          ./nixos/configuration.nix
          ./users/sargo.nix
          ./users/root.nix
        ];
      in {
        packages = {
          formatter.${system} =
            (import nixpkgs-unstable { inherit system; }).nil;
          nixosConfigurations = {

            SargoSummit = nixpkgs.lib.nixosSystem {
              inherit system specialArgs;
              modules = default_modules
                ++ [ ./hosts/summit.nix ./nixos/finger_print.nix ];
            };

            SargoLaptop = nixpkgs.lib.nixosSystem {
              inherit specialArgs;
              modules = default_modules ++ [ ./hosts/laptop.nix ];
            };

          };

        };
        devShells = {
          bootstrap = let pkgs = nixpkgs.legacyPackages.${system};
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
