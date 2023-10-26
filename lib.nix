with builtins; rec {
  mkSystem = { system_modules, users, specialArgs }:
    let
      imported-users = map (x: import x) users;
      extra_system_options =
        foldl' (prev: item: prev // item.extra_system_options) { }
        imported-users;
      user_unified_modules =
        get_list_attr_value imported-users "unified_modules";
      user_nixos_modules = (get_list_attr_value imported-users "nixos_modules")
        ++ (get_list_attr_value user_unified_modules "nixos");
    in nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = specialArgs // extra_system_options;
      modules = system_modules ++ user_nixos_modules;
    };

  # Creates an importable module from a user config
  mkUser = user: {
    users.user.${user.name} = user.module // {
      imports = [
        home-manager.nixosModules.home-manager
        {
          home-manager.users.${user.name} = { lib, ... }:
            {
              imports = map (x:
                (if builtins.isFunction x then x else import x)
                (args // user.extra_home_options)) user.home_modules;
            } // user.home_module;
        }
      ];

    };

  };

  get_list_attr_value = list: key:
    concatLists (map (set: getAttr key set) list);

  user_example = {
    name = "bob";
    # Unified modules can contain nixos, home manager and aditional config options to be passed
    unified_modules = [ ./users/sargo.nix ];
    # Home manager modules to import
    home_modules = [ ./home/git.nix ];
    # NixOS modules to import
    nixos_modules = [ ./nixos/virt-manager.nix ];
    # Nixos user config, options that are usally avalible under users.users.${name}
    module = {

    };

    home_module = {

    };

    # Options to be passed to all modules
    extra_system_options = { system = "x86_64-linux"; };
    # Options to be passed to all home manager modules modules for a user
    extra_home_options = { browser = "firefox"; };
  };

  # Unified modules can contain a nixos module, home manager module as well as aditional config options to be passed to various modules
  unified_module_example = {
    # The home manager module
    home = { imports = [ ./home/git.nix ]; };
    # The nixos module
    nixos = { imports = [ ./nixos/virt-manager.nix ]; };
    # Options to be passed to all modules
    system_options = { system = "x86_64-linux"; };
    # Options to be passed to all home manager modules modules for a user
    home_options = { browser = "firefox"; };
  };

  example_config = mkSystem {
    modules = [ 
      overlays 
      "configuration"
      "summit"
      "finger_print"
      "thunar"
      "waydroid"
      "virt-manager"
    ];
    users = {
      sargo = {
        unified_modules = [ 
          "hyprland"
        ];
        home_modules = [ 
          ./misc/future_hyprland_module.nix
          "foot"
          "firefox"
          "dark-theme"
          "wavefox"
          "mime"
        ];
        nixos_modules = [ 
          "virt-manager"
        ];
        module = {
          shell = pkgs.unstable.fish;
          isNormalUser = true;
          initialHashedPassword =
            "$6$Z7Ty/RzwsUJtd43I$6dCbqpYN1HOhTr5EoEgu6XyctK8lCYu6OqJGzREOjR5L0i6mn12vl2wF.nJzrAxqTCIl5idftqSOPI8WLNVky0";
          description = "Oliver Sargison";
          extraGroups = [ "networkmanager" "wheel" ];
        };

        home_module = {
          home.username = "sargo";
          home.homeDirectory = "/home/sargo";
          home.stateVersion = "23.05";
        };
        extra_system_options = { };
        extra_home_options = { browser = "firefox"; };
      };
    };
  }
  
  {
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
}

