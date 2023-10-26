{ extra-home-modules ? [ ], home-manager, pkgs, ... }@args: {
  users.users.sargo = {
    shell = pkgs.unstable.fish;
    isNormalUser = true;
    initialHashedPassword =
      "$6$Z7Ty/RzwsUJtd43I$6dCbqpYN1HOhTr5EoEgu6XyctK8lCYu6OqJGzREOjR5L0i6mn12vl2wF.nJzrAxqTCIl5idftqSOPI8WLNVky0";
    description = "Oliver Sargison";
    extraGroups = [ "networkmanager" "wheel" ];
  };
  security.sudo.extraRules = [{
    users = [ "sargo" ];
    commands = [{
      command = "ALL";
      options =
        [ "NOPASSWD" ]; # "SETENV" # Adding the following could be a good idea
    }];
  }];
  imports = [
    home-manager.nixosModules.home-manager
    {
      # home-manager.useGlobalPkgs = true;

      home-manager.backupFileExtension = ".bak";
      # home-manager.useUserPackages = true;
      home-manager.users.sargo = { lib, ... }:
        let
          palette = (import ../misc/palettes.nix).gruvbox;
          browser = "firefox";
          terminal = "kitty";

        in {
          imports = map (x:
            (if builtins.isFunction x then x else import x)
            (args // { inherit palette browser terminal lib pkgs; })) ([
              ../home/bash.nix
              ../home/fish.nix
              ../home/helix.nix
              ../home/nu.nix
              ../home/lf.nix
              ../home/starship.nix
              ../home/waybar.nix
              ../home/zellij.nix
              ../home/zoxide.nix
            ] ++ extra-home-modules);
          services.mpris-proxy.enable = true;
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
            bash = { enable = true; };
          };

          # services.pueue.enable = true;
          home.username = "sargo";
          home.homeDirectory = "/home/sargo";
          home.stateVersion = "23.05";

          home.file.".config/wofi/style.css".text = # css
            ''
              @define-color base   #24272a; @define-color mantle #1e2030; @define-color crust  #181926;  @define-color text     #cad3f5; @define-color subtext0 #a5adcb; @define-color subtext1 #b8c0e0;  @define-color surface0 #363a4f; @define-color surface1 #494d64; @define-color surface2 #5b6078;  @define-color overlay0 #6e738d; @define-color overlay1 #8087a2; @define-color overlay2 #939ab7;  @define-color blue      #8aadf4; @define-color lavender  #b7bdf8; @define-color sapphire  #7dc4e4; @define-color sky       #91d7e3; @define-color teal      #8bd5ca; @define-color green     #a6da95; @define-color yellow    #eed49f; @define-color peach     #f5a97f; @define-color maroon    #ee99a0; @define-color red       #ed8796; @define-color mauve     #c6a0f6; @define-color pink      #f5bde6; @define-color flamingo  #f0c6c6; @define-color rosewater #f4dbd6;  window { margin: 0px; border-radius: 30px; border: 2px solid #fe8019; }  #input { margin: 5px; border: none; border-radius: 30px; }  #inner-box { margin: 5px; border: none; border-radius: 30px; }  #outer-box { margin: 15px; border: none; }  #scroll { margin: 0px; border: none; }  #text { margin: 5px; border: none; }   #entry:selected { border-radius: 20px; outline: none; }  #entry:selected * { border-radius: 20px; outline: none; } 
            '';
        };

    }

  ];

}

