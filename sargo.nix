{ config, pkgs, ... }: {
  users.users.sargo = {
    isNormalUser = true;
    initialHashedPassword =
      "$6$Z7Ty/RzwsUJtd43I$6dCbqpYN1HOhTr5EoEgu6XyctK8lCYu6OqJGzREOjR5L0i6mn12vl2wF.nJzrAxqTCIl5idftqSOPI8WLNVky0";
    description = "Oliver Sargison";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      gitui
      pastel
      speedcrunch
      glava
      swayimg
      nixfmt
      unstable.marksman
      unstable.zellij
      inlyne
      swaybg
      feh
      zathura
      galculator
      networkmanagerapplet
      blueman
      pcmanfm
      blueberry
      chafa
      htop
      wlogout
      libreoffice
      keepassxc
      firefox
      unstable.nil
      delta
      felix-fm
      trash-cli
      fish
      kitty
      xplr
      fzf
      ripgrep
      wl-clipboard
      wofi
      xclip
      wget
      btop
      exa
      sd
      zoxide
      unstable.starship
    ];
  };

  home-manager.users.sargo = { pkgs, lib, ... }:
    let
      unstableTarball = fetchTarball
        "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";

      flake-compat = builtins.fetchTarball
        "https://github.com/edolstra/flake-compat/archive/master.tar.gz";

      hyprland = (import flake-compat {
        src = fetchGit {
          url = "https://github.com/hyprwm/Hyprland";
          rev = "edad24c257c1264e2d0c05b04798b6c90515831e";
        };
      }).defaultNix;
    in {

      imports = [
        hyprland.homeManagerModules.default
        ./waybar.nix
        ./zellij.nix
        ./hyprland.nix
        ./fish.nix
        ./alacritty.nix
        ./starship.nix
        ./kitty.nix
        ./lf.nix
        ./helix.nix
        ./dconf.nix
      ];

      programs = {
        home-manager.enable = true;

        bat = {
          enable = true;
          config = { theme = "gruvbox-dark"; };
        };
        lazygit = {
          enable = true;
          settings = {
            git = {
              autofetch = true;
              paging = {
                colorarg = "always";
                colorArg = "always";
                pager = # bash
                  "delta --dark --paging=never --24-bit-color=never";
              };
            };
          };
        };

        direnv = {
          nix-direnv.enable = true;
          enable = true;
        };
        git = {
          enable = true;
          userName = "Oliver Sargison";
          userEmail = "sargo@sargo.cc";
          delta.enable = true;
        };
      };

      nixpkgs.overlays = [
        (self: super: {
          waybar = super.waybar.overrideAttrs (oldAttrs: {
            mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
          });
        })
      ];
      nixpkgs.config = {
        packageOverrides = pkgs: {
          unstable = import unstableTarball { config = config.nixpkgs.config; };
        };
      };
      home.username = "sargo";
      home.homeDirectory = "/home/sargo";
      home.stateVersion = "22.11";

      services.gammastep = {
        enable = true;
        latitude = -36.8;
        longitude = 174.8;
      };



      # home.file.".cargo/config.toml".text = /*toml*/ ''

      #   [target.x86_64-unknown-linux-gnu]
      #   linker = "clang"
      #   rustflags = ["-C", "link-arg=-fuse-ld=${pkgs.mold}/bin/mold"]
      # '';

      home.file.".config/hypr/hyprpaper.conf".text = # toml
        ''
          preload = ~/nix-files/gruv-material-texture.png

          wallpaper = HDMI-A-1,~/nix-files/gruv-material-texture.png
          wallpaper = eDP-1,~/nix-files/gruv-material-texture.png
        '';

      home.file.".config/wofi/style.css".text = # css
        ''
          @define-color base   #24273a; @define-color mantle #1e2030; @define-color crust  #181926;  @define-color text     #cad3f5; @define-color subtext0 #a5adcb; @define-color subtext1 #b8c0e0;  @define-color surface0 #363a4f; @define-color surface1 #494d64; @define-color surface2 #5b6078;  @define-color overlay0 #6e738d; @define-color overlay1 #8087a2; @define-color overlay2 #939ab7;  @define-color blue      #8aadf4; @define-color lavender  #b7bdf8; @define-color sapphire  #7dc4e4; @define-color sky       #91d7e3; @define-color teal      #8bd5ca; @define-color green     #a6da95; @define-color yellow    #eed49f; @define-color peach     #f5a97f; @define-color maroon    #ee99a0; @define-color red       #ed8796; @define-color mauve     #c6a0f6; @define-color pink      #f5bde6; @define-color flamingo  #f0c6c6; @define-color rosewater #f4dbd6;  window { margin: 0px; border-radius: 30px; border: 2px solid #fe8019; }  #input { margin: 5px; border: none; border-radius: 30px; }  #inner-box { margin: 5px; border: none; border-radius: 30px; }  #outer-box { margin: 15px; border: none; }  #scroll { margin: 0px; border: none; }  #text { margin: 5px; border: none; }   #entry:selected { border-radius: 20px; outline: none; }  #entry:selected * { border-radius: 20px; outline: none; } 
        '';

    };
}

