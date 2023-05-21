{ hyprland, pkgs, nuscripts,helix-pkg, ... }: {
  users.users.sargo = {
    isNormalUser = true;
    initialHashedPassword =
      "$6$Z7Ty/RzwsUJtd43I$6dCbqpYN1HOhTr5EoEgu6XyctK8lCYu6OqJGzREOjR5L0i6mn12vl2wF.nJzrAxqTCIl5idftqSOPI8WLNVky0";
    description = "Oliver Sargison";
    extraGroups = [ "networkmanager" "wheel" ];
  };
  home-manager.users.sargo = { lib, ... }:
    let
      palette = {
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

      browser = "librewolf";

    in {

      imports =
        map (x: import x { inherit pkgs lib palette nuscripts browser helix-pkg; }) [
          ./alacritty.nix
          ./dconf.nix
          ./fish.nix
          ./helix.nix
          ./hyprland.nix
          ./kitty.nix
          ./nu.nix
          ./lf.nix
          ./starship.nix
          ./waybar.nix
          ./zellij.nix
          ./zoxide.nix
        ] ++ [ hyprland.homeManagerModules.default ];
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
      };

      services.pueue.enable = true;

      home.username = "sargo";
      home.homeDirectory = "/home/sargo";
      home.stateVersion = "22.11";

      # home.file.".cargo/config.toml".text = /*toml*/ ''

      #   [target.x86_64-unknown-linux-gnu]
      #   linker = "clang"
      #   rustflags = ["-C", "link-arg=-fuse-ld=${pkgs.mold}/bin/mold"]
      # '';

      home.file.".config/hypr/shader.glsl".text = # glsl
        ''
          precision mediump float;
          varying vec2 v_texcoord;
          uniform sampler2D tex;

          void main() {

              vec4 pixColor = texture2D(tex, v_texcoord);
              pixColor.xyz = smoothstep(0.,1.,pixColor.xyz);

              gl_FragColor = pixColor;
          }
        '';

      home.file.".config/hypr/shader_eye_saver.glsl".text = # glsl
        ''
          precision mediump float;
          varying vec2 v_texcoord;
          uniform sampler2D tex;

          void main() {

              vec4 pixColor = texture2D(tex, v_texcoord);

              pixColor.rgb = smoothstep(0.,1.,pixColor.rgb) 
                  * vec3(1, 0.5, .2) * 0.3;    

              gl_FragColor = pixColor;
          }
        '';

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

