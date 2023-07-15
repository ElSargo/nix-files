{ hyprland, system, home-manager, pkgs, ... }@args: {
  users.users.sargo = {
    isNormalUser = true;
    initialHashedPassword =
      "$6$Z7Ty/RzwsUJtd43I$6dCbqpYN1HOhTr5EoEgu6XyctK8lCYu6OqJGzREOjR5L0i6mn12vl2wF.nJzrAxqTCIl5idftqSOPI8WLNVky0";
    description = "Oliver Sargison";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = [
      args.unix-chad-bookmarks.defaultPackage.${system}
      args.new-terminal-hyprland.defaultPackage.${system}
      args.nvim.packages.${system}.default
      args.wgsl.packages.${system}.default
      pkgs.eww

    ];
  };
  security.sudo.extraRules = [{
  users = [ "sargo" ];
  commands = [{
    command = "ALL";
    options =
      [ "NOPASSWD" ]; # "SETENV" # Adding the following could be a good idea
  }];
}];
  imports = [ (import "${home-manager}/nixos") ];
  home-manager.users.sargo = { lib, ... }:
    let
      palettes = {
        gruvbox = {
          helix_theme = "gruvy";
          aqua = "#689d6a";
          bg = "#282828"; # main background
          bg2 = "#504945";
          bg3 = "#665c54";
          bg4 = "#7c6f64";
          blue = "#458588";
          br_aqua = "#8ec07c";
          br_bg = "#3c3836";
          br_blue = "#83a598";
          br_fg = "#ebdbb2"; # main foreground
          br_gray = "#928374";
          br_green = "#b8bb26";
          br_orange = "#fe8019";
          br_purple = "#d3869b";
          br_red = "#fb4934";
          br_yellow = "#fabd2f";
          fg = "#fbf1c7";
          fg2 = "#d5c4a1";
          fg3 = "#bdae93";
          fg4 = "#a89984"; # gray0
          gray = "#a89984";
          green = "#98971a";
          orange = "#d65d0e";
          purple = "#b16286";
          red = "#cc241d";
          tan = "#bdae93";
          white = "#fbf1c7";
          yellow = "#d79921";
        };
        tokionight = rec {
          helix_theme = "tokio";
          aqua = "#89ddff";
          bg = "#16161e"; # main background
          bg2 = "#373d5a";
          bg3 = br_bg;
          bg4 = bg3;
          blue = "#7aa2f7";
          br_aqua = "#b4f9f8";
          br_bg = "#1f2335";
          br_blue = "#2ac3de";
          br_gray = "#9aa5ce";
          br_green = "#9ece6a";
          br_orange = br_aqua;
          br_purple = "#bb9af7";
          br_red = red;
          br_yellow = yellow;
          fg = "#a9b1d6";
          br_fg = "#c0caf5"; # main foreground
          fg2 = "#363b54";
          fg3 = br_fg;
          fg4 = br_blue; # gray0
          gray = br_gray;
          green = "#73daca";
          orange = "#ff9e64";
          purple = "#7dcfff";
          red = "#f7768e";
          tan = blue;
          white = "#c0caf5";
          yellow = "#e0af68";
        };
      };

      palette = palettes.gruvbox;
      browser = "firefox";
      terminal = "foot";

    in {
      imports = map
        (x: import (x) (args // { inherit palette browser terminal lib pkgs; })) [
          ../home/alacritty.nix
          ../home/dconf.nix
          ../home/fish.nix
          ../home/helix.nix
          ../home/hyprland.nix
          ../home/foot.nix
          ../home/firefox.nix
          ../home/kitty.nix
          ../home/nu.nix
          ../home/lf.nix
          ../home/starship.nix
          ../home/waybar.nix
          ../home/zellij.nix
          ../home/zoxide.nix
        ] ++ [ hyprland.homeManagerModules.default ];
      services.mpris-proxy.enable = true;
      programs = {
        home-manager.enable = true;
        nix-index.enable = true;
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
        bash = { enable = true; };
      };

      services.pueue.enable = true;
      home.username = "sargo";
      home.homeDirectory = "/home/sargo";
      home.stateVersion = "23.05";



      home.file.".config/wofi/style.css".text = # css
        ''
          @define-color base   #24273a; @define-color mantle #1e2030; @define-color crust  #181926;  @define-color text     #cad3f5; @define-color subtext0 #a5adcb; @define-color subtext1 #b8c0e0;  @define-color surface0 #363a4f; @define-color surface1 #494d64; @define-color surface2 #5b6078;  @define-color overlay0 #6e738d; @define-color overlay1 #8087a2; @define-color overlay2 #939ab7;  @define-color blue      #8aadf4; @define-color lavender  #b7bdf8; @define-color sapphire  #7dc4e4; @define-color sky       #91d7e3; @define-color teal      #8bd5ca; @define-color green     #a6da95; @define-color yellow    #eed49f; @define-color peach     #f5a97f; @define-color maroon    #ee99a0; @define-color red       #ed8796; @define-color mauve     #c6a0f6; @define-color pink      #f5bde6; @define-color flamingo  #f0c6c6; @define-color rosewater #f4dbd6;  window { margin: 0px; border-radius: 30px; border: 2px solid #fe8019; }  #input { margin: 5px; border: none; border-radius: 30px; }  #inner-box { margin: 5px; border: none; border-radius: 30px; }  #outer-box { margin: 15px; border: none; }  #scroll { margin: 0px; border: none; }  #text { margin: 5px; border: none; }   #entry:selected { border-radius: 20px; outline: none; }  #entry:selected * { border-radius: 20px; outline: none; } 
        '';
    };
}

