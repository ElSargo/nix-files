{
  inputs = {

    nixpkgs.url = "nixpkgs/nixos-23.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";

    home-manager.url = "github:nix-community/home-manager/release-23.05";
    flake-utils.url = "github:numtide/flake-utils";
    nuscripts = {
      url = "github:nushell/nu_scripts";
      flake = false;
    };
    firefox-gnome-theme = {
      url = "github:rafaelmardojai/firefox-gnome-theme";
      flake = false;
    };

    hyprland = {
      url = "github:hyprwm/Hyprland/51a930f802c71a0e67f05e7b176ded74e8e95f87";
      inputs.nixpkgs.follows = "nixpkgs";
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
    , helix-flake, supabar, nvim, wgsl, zellij-runner, unix-chad-bookmarks
    , firefox-gnome-theme, eww-bar, new-terminal-hyprland, hyprland, ...
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
            supabar.overlays.${system}.default
            nvim.overlays.${system}.default
            wgsl.overlays.${system}.default
            eww-bar.overlays.${system}.default
            new-terminal-hyprland.overlays.${system}.default

            zellij-runner.overlays.${system}.default
          ];
        });
        specialArgs = attrs // { inherit system helix; };
        default_modules = [
          overlays
          nur.nixosModules.nur
          ./nixos/configuration.nix
          ./users/root.nix
        ];
      in {
        packages = {
          formatter.${system} =
            (import nixpkgs-unstable { inherit system; }).nil;
          nixosConfigurations = {

            SargoSummit = nixpkgs.lib.nixosSystem {
              inherit system;
              specialArgs = specialArgs // {
                inherit firefox-gnome-theme;
                extra-home-modules =
                  [ ./home/dconf.nix ./home/kitty.nix ./home/firefox.nix ];
              };
              modules = default_modules ++ [
                ./hosts/summit.nix
                ./nixos/finger_print.nix
                ./nixos/gnome.nix
              ];
            };

            ChadBook = nixpkgs.lib.nixosSystem {
              inherit system;
              specialArgs = specialArgs // {
                firefox-gnome-theme = null;
                extra-home-modules = [
                  ./misc/future_hyprland_module.nix
                  ./home/hyprland.nix
                  ./home/foot.nix
                  ./home/firefox.nix
                  ./home/dark-theme.nix
                ];

              };
              modules = default_modules ++ [
                ./hosts/summit.nix
                ./nixos/finger_print.nix
                ./nixos/hyprland.nix
                ./users/sargo.nix
                ./nixos/waydroid.nix
              ];
            };

            SargoLaptop = nixpkgs.lib.nixosSystem {
              inherit specialArgs;
              modules = default_modules ++ [ ./hosts/laptop.nix ];
            };

            container = nixpkgs.lib.nixosSystem {
              inherit specialArgs;
              modules = [
                {
                  nixpkgs = { config.allowUnfree = true; };
                  nixpkgs.hostPlatform = "x86_64-linux";
                  time.timeZone = "Pacific/Auckland";
                  i18n = {
                    extraLocaleSettings = {
                      LC_ADDRESS = "en_NZ.UTF-8";
                      LC_IDENTIFICATION = "en_NZ.UTF-8";
                      LC_MEASUREMENT = "en_NZ.UTF-8";
                      LC_MONETARY = "en_NZ.UTF-8";
                      LC_NAME = "en_NZ.UTF-8";
                      LC_NUMERIC = "en_NZ.UTF-8";
                      LC_PAPER = "en_NZ.UTF-8";
                      LC_TELEPHONE = "en_NZ.UTF-8";
                      LC_TIME = "en_NZ.UTF-8";
                    };
                  };
                  fileSystems."/" = {
                    fsType = "ext4";
                    device =
                      "/dev/disk/by-uuid/ab032e3a-09d1-43eb-85df-1b6ea66d99eb";
                  };
                  system.stateVersion = "23.05";
                  boot.loader.systemd-boot.enable = true;
                  boot.loader.efi.canTouchEfiVariables = true;

                }
                {
                  nix.settings = {
                    warn-dirty = false;
                    experimental-features = [ "nix-command" "flakes" ];
                  };
                }
                {
                  users.users.sargo = {
                    isNormalUser = true;
                    description = "Oliver Sargison";
                    extraGroups = [ "networkmanager" "wheel" ];
                    initialHashedPassword =
                      "$6$Z7Ty/RzwsUJtd43I$6dCbqpYN1HOhTr5EoEgu6XyctK8lCYu6OqJGzREOjR5L0i6mn12vl2wF.nJzrAxqTCIl5idftqSOPI8WLNVky0";

                  };
                }
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
