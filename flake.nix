{
  inputs = {

    nixpkgs.url = "nixpkgs/nixos-23.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-23.05";
    flake-utils.url = "github:numtide/flake-utils";
    nuscripts = {
      url = "github:nushell/nu_scripts";
      flake = false;
    };
    wave-fox = {
      url = "github:QNetITQ/WaveFox";
      flake = false;
    };
    firefox-gnome-theme = {
      url = "github:rafaelmardojai/firefox-gnome-theme";
      flake = false;
    };

    hyprland.url = "github:hyprwm/Hyprland";
    hypr-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      flake = false;
    };

    eww-bar = {
      url = "github:ElSargo/eww-bar";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    helix-flake = {
      url = "github:the-mikedavis/helix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    new-terminal-hyprland = {
      url = "github:ElSargo/new-terminal-hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    unix-chad-bookmarks = {
      url = "github:ElSargo/unix-chad-bookmarks";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    supabar.url = "github:ElSargo/supabar";
    nvim.url = "github:ElSargo/nvim";
    wgsl = {
      url = "github:ElSargo/wgsl-analyzer";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, flake-utils, home-manager
    , helix-flake, supabar, nvim, wgsl, unix-chad-bookmarks, firefox-gnome-theme
    , wave-fox, eww-bar, new-terminal-hyprland, hyprland, ... }@attrs:
    flake-utils.lib.eachDefaultSystem (system:

      let
        unstable-overlay = final: prev: {
          unstable = import nixpkgs-unstable {
            inherit system;
            config.allowUnfree = true;
          };
        };
        change_wallpaper_overlay = final: prev: {
          change-wallpaper = import ./misc/change_wall.nix { pkgs = prev; };
        };
        helix = helix-flake.packages.${system}.default;
        overlays = ({ config, pkgs, ... }: {
          nixpkgs.overlays = [
            unstable-overlay
            unix-chad-bookmarks.overlays.${system}.default
            nvim.overlays.${system}.default
            wgsl.overlays.${system}.default
            eww-bar.overlays.${system}.default
            new-terminal-hyprland.overlays.${system}.default
            change_wallpaper_overlay
            supabar.overlays.${system}.all
          ];
        });
        specialArgs = attrs // { inherit system helix; };
        default_modules =
          [ overlays ./nixos/configuration.nix ./users/root.nix ];
      in {
        packages = {
          formatter.${system} =
            (import nixpkgs-unstable { inherit system; }).nil;
          nixosConfigurations = {

            SargoSummit = nixpkgs.lib.nixosSystem {
              inherit system;
              specialArgs = specialArgs // {
                firefox-theme = firefox-gnome-theme;
                extra-home-modules = [
                  ./home/dconf.nix
                  ./home/kitty.nix
                  ./home/firefox.nix
                  ./home/firefox_gnome_theme.nix
                  ./home/dark-theme.nix
                ];
              };
              modules = default_modules ++ [
                ./hosts/summit.nix
                ./nixos/finger_print.nix
                ./nixos/gnome.nix
                ./users/sargo.nix
              ];
            };

            PlasmaBook = nixpkgs.lib.nixosSystem {
              inherit system;
              specialArgs = specialArgs // {
                firefox-theme = null;
                extra-home-modules = [ ./home/kitty.nix ./home/firefox.nix ];
              };
              modules = default_modules ++ [
                ./hosts/summit.nix
                ./nixos/finger_print.nix
                ./users/sargo.nix
                ./nixos/plasma.nix
              ];
            };

            ChadBook = nixpkgs.lib.nixosSystem {
              inherit system;
              specialArgs = specialArgs // {
                firefox-theme = wave-fox;
                extra-home-modules = [
                  ./misc/future_hyprland_module.nix
                  ./home/hyprland.nix
                  ./home/foot.nix
                  ./home/firefox.nix
                  ./home/dark-theme.nix
                  ./home/wavefox.nix
                  ./home/mime.nix
                ];

              };
              modules = default_modules ++ [
                ./hosts/summit.nix
                ./nixos/finger_print.nix
                ./nixos/hyprland.nix
                ./users/sargo.nix
                ./nixos/thunar.nix
                # ./nixos/waydroid.nix
                ./nixos/virt-manager.nix

              ];
            };

            SargoLaptop = nixpkgs.lib.nixosSystem {
              inherit system;
              specialArgs = specialArgs // {
                firefox-theme = firefox-gnome-theme;
                extra-home-modules = [
                  ./misc/future_hyprland_module.nix
                  ./home/hyprland.nix
                  ./home/foot.nix
                  ./home/firefox.nix
                  ./home/dark-theme.nix
                  ./home/wave-fox.nix
                ];

              };
              modules = default_modules ++ [
                ./hosts/laptop.nix
                ./nixos/hyprland.nix
                ./users/sargo.nix
              ];
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
