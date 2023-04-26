{ config, pkgs, ... }:
let
  mozillaOverlay = import (fetchTarball
    "https://github.com/mozilla/nixpkgs-mozilla/archive/master.tar.gz");

  home-manager = fetchTarball
    "https://github.com/nix-community/home-manager/archive/master.tar.gz";

  unstableTarball = fetchTarball
    "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";

  flake-compat = fetchTarball
    "https://github.com/edolstra/flake-compat/archive/master.tar.gz";

  hyprland = (import flake-compat {
    src = fetchGit {
      url = "https://github.com/hyprwm/Hyprland";
      rev = "edad24c257c1264e2d0c05b04798b6c90515831e";
    };
  }).defaultNix;

  # hyprland = (import flake-compat {
  #   src =
  #     fetchTarball "https://github.com/hyprwm/Hyprland/archive/master.tar.gz";
  # }).defaultNix;

  # stylix = pkgs.fetchFromGitHub {
  #   owner = "danth";
  #   repo = "stylix";
  #   rev = "...";
  #   sha256 = "...";
  # };

in {
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  # programs.hyprland = {
  #   enable = true;
  #   package = hyprland.packages.${pkgs.system}.default;
  # };
  #//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  # User setup
  #//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  users.defaultUserShell = pkgs.fish;

  # Enable networking
  networking.networkmanager.enable = true;
  networking.firewall.allowedTCPPorts = [ 22 ];
  networking.hostName = "SargoLaptop"; # Define your hostname.

  services.xserver = {
    enable = true;
    desktopManager = {
      xterm.enable = false;
      gnome.enable = true;
    };

    displayManager.gdm.enable = true;
    # displayManager = { defaultSession = "hyprland"; };
    libinput.enable = true;
    excludePackages = [ pkgs.xterm pkgs.gnome.gnome-terminal ];
    layout = "us";
    # xkbVariant = "colemak";
  };
  qt5.enable = true;
  qt5.platformTheme = "gtk2";
  qt5.style = "gtk2";
  xdg.portal.wlr.enable = true;
  # Enable CUPS to print documents.
  services.printing.enable = true;
  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # jack.enable = true;
  };
  security.sudo.extraRules = [{
    users = [ "sargo" ];
    commands = [{
      command = "ALL";
      options =
        [ "NOPASSWD" ]; # "SETENV" # Adding the following could be a good idea
    }];
  }];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.initrd.secrets = { "/crypto_keyfile.bin" = null; };
  boot.initrd.luks.devices."luks-4955bc2c-1e9b-4a8b-ab6d-125ca5b3e064".device =
    "/dev/disk/by-uuid/4955bc2c-1e9b-4a8b-ab6d-125ca5b3e064";
  boot.initrd.luks.devices."luks-4955bc2c-1e9b-4a8b-ab6d-125ca5b3e064".keyFile =
    "/crypto_keyfile.bin";
  boot.kernelPackages = pkgs.unstable.linuxPackages_latest;
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  services.dbus.enable = true;
  services.blueman.enable = true;
  services.openssh.enable = true;
  services.openssh.permitRootLogin = "no";
  #Enable blutooth
  hardware.bluetooth.enable = true;

  # stylix.image = /home/sargo/nix-files/gruv-material-texture.png;

  system.stateVersion = "22.11"; # Did you read the comment?
  nixpkgs.overlays = [
    (self: super: {
      waybar = super.waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      });
    })
    mozillaOverlay
  ];
  nixpkgs.config.packageOverrides = pkgs: {
    unstable = import unstableTarball { config = config.nixpkgs.config; };
  };
  # nix.settings = {
  #   substituters = [ "https://hyprland.cachix.org" ];
  #   trusted-public-keys =
  #     [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  # };
  imports = [
    # (import stylix).homeManagerModules.stylix 
    ./hardware-configuration.nix
    ./sargo.nix
    ./system-pakages.nix
    (import "${home-manager}/nixos")
    hyprland.nixosModules.default
  ];
  nixpkgs.config.allowUnfree = true;
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

  system.autoUpgrade.enable = true;
  programs.hyprland.enable = true;
  # wayland.windowManager.hyprland = {
  #       enable = true;
  #       extraConfig = # zig
  #         ''
  #           # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
  #           bind = SUPER, Return, exec, projects/new-terminal-hyprland/target/release/new-terminal-hyprland
  #           bind = SUPER, L, exec, projects/new-terminal-hyprland/target/release/new-terminal-hyprland lazygit
  #           bind = SUPER, T, exec, projects/new-terminal-hyprland/target/release/new-terminal-hyprland cargo test
  #           bind = SUPER, R, exec, projects/new-terminal-hyprland/target/release/new-terminal-hyprland cargo run
  #           bind = SUPERSHIFT, R, exec, projects/new-terminal-hyprland/target/release/new-terminal-hyprland cargo run --release

  #           bind = SUPER, G, exec, projects/unixchadbookmarks/target/release/unixchadbookmarks
  #           bind = SUPER, C, exec, fish -c open_system
  #           bind = SUPER, Q, killactive, 
  #           bind = SUPERSHIFT, F, exec, pcmanfm
  #           bind = SUPERSHIFT, Space, togglefloating, 
  #           bind = SUPERSHIFT, Return, exec, wofi --show drun
  #           bind = SUPER, P, pseudo, # dwindle
  #           bind = SUPER, W, exec, librewolf
  #           bind = SUPER, F,fullscreen,0
  #           bind = SUPERSHIFT, Q, exec, wlogout
  #           bind = SUPER, B, exec, blueberry
  #           bind = SUPERSHIFT, W, exec, nm-connection-editor
  #           bind = SUPERSHIFT, Z, exec, kitty fish '-c zn'
  #           bind = SUPER, J, layoutmsg, cyclenext
  #           bind = SUPER, K, layoutmsg, cycleprev 
  #           bind = SUPERSHIFT, J, layoutmsg, swapnext
  #           bind = SUPERSHIFT, K, layoutmsg, swapprev 
  #           bind = SUPER SHIFT, w, workspace, browser
  #           bind = SUPER, V, layoutmsg, focusmaster
  #           bind = SUPER, Space, layoutmsg, swapwithmaster
  #           bind = SUPER, p, exec, librewolf search.nixos.org/packages?channel=22.11&query=
  #           bind = ,XF86AudioLowerVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ -5% 	
  #           bind = ,XF86AudioRaiseVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ +5%
  #           bind = ,XF86AudioMute, exec, pactl set-sink-volume @DEFAULT_SINK@ 0% 	
  #           bind = ,XF86Calculator, exec, galculator 	
  #           bind = ,XF86Mail, exec, librewolf mail.google.com/mail/u/0/#inbox
  #           bind = ,XF86KbdBrightnessUp, exec,  
  #           bind = ,XF86KbdBrightnessDown , exec, 
  #           unbind, SUPER, M
  #           bind = SUPER, 1, workspace, 1
  #           bind = SUPER, 2, workspace, 2
  #           bind = SUPER, 3, workspace, 3
  #           bind = SUPER, 4, workspace, 4
  #           bind = SUPER, 5, workspace, 5
  #           bind = SUPER, 6, workspace, 6
  #           bind = SUPER, 7, workspace, 7
  #           bind = SUPER, 8, workspace, 8
  #           bind = SUPER, 9, workspace, 9
  #           bind = SUPER, 0, workspace, 10
  #           bind = SUPER SHIFT, 1, movetoworkspace, 1
  #           bind = SUPER SHIFT, 2, movetoworkspace, 2
  #           bind = SUPER SHIFT, 3, movetoworkspace, 3
  #           bind = SUPER SHIFT, 4, movetoworkspace, 4
  #           bind = SUPER SHIFT, 5, movetoworkspace, 5
  #           bind = SUPER SHIFT, 6, movetoworkspace, 6
  #           bind = SUPER SHIFT, 7, movetoworkspace, 7
  #           bind = SUPER SHIFT, 8, movetoworkspace, 8
  #           bind = SUPER SHIFT, 9, movetoworkspace, 9
  #           bind = SUPER SHIFT, 0, movetoworkspace, 10
  #           bind=SUPER_SHIFT,S,movetoworkspace,special
  #           bind=SUPER,S,togglespecialworkspace,
  #           bind = SUPER, mouse_down, workspace, e+1
  #           bind = SUPER, mouse_up, workspace, e-1
  #           bindm = SUPER, mouse:272, movewindow
  #           bindm = SUPER, mouse:273, resizewindow

  #           monitor=HDMI-A-1,preferred,auto,1
  #           monitor=HDMI-A-1,transform,1
  #           workspace=HDMI-A-1,1

  #           exec = fish -c 'pidof waybar || waybar & disown'
  #           exec = fish -c 'pidof swaybg || swaybg -i ~/nix-files/gruv-material-texture.png & disown'
  #           input {
  #               kb_layout = us
  #               # kb_variant = colemak
  #               kb_options=caps:escape
  #               repeat_rate=69
  #               repeat_delay=150
  #               follow_mouse = 1
  #               touchpad {
  #                   natural_scroll = no
  #               }
  #               sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
  #           }
  #           general {
  #               gaps_in = 5
  #               gaps_out = 7
  #               border_size = 2
  #               col.active_border = rgb(fe8019) 
  #               col.inactive_border = rgb(282828)
  #               layout = master
  #           }
  #           decoration {
  #               screen_shader = ~/.config/hypr/shader.glsl
  #               rounding = 10
  #               blur = yes
  #               blur_size = 4
  #               blur_passes = 1
  #               blur_new_optimizations = on

  #               drop_shadow = true
  #               shadow_range = 20
  #               shadow_render_power = 3
  #               col.shadow = rgba(1a1a1aee)
  #               shadow_offset = [-10, -10]
  #           }
  #           animations {
  #               enabled = yes
  #               bezier = myBezier, 0.05, 0.9, 0.1, 1.05
  #               animation = windows, 1, 7, default, slide
  #               animation = windowsOut, 1, 11, default, slide
  #               # animation = windowsOut, 1, 7, default, popin 80%
  #               animation = border, 1, 10, default
  #               animation = fade, 1, 7, default
  #               animation = workspaces, 1, 6, default
  #           }
  #           dwindle {
  #               pseudotile = yes # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
  #               preserve_split = yes # you probably want this
  #           }
  #           master {
  #               new_is_master = true
  #               new_on_top = true
  #           }
  #           gestures {
  #               # See https://wiki.hyprland.org/Configuring/Variables/ for more
  #               workspace_swipe = on
  #               workspace_swipe_forever = true;
  #               workspace_swipe_cancel_ratio = 0.25;
  #           }
  #           windowrule = float, ^(blueberry.py)$
  #           windowrule = float, ^(nm-connection-editor)$
  #           windowrule = float, ^(pavucontrol)$
  #           windowrule = float, ^(galculator)$

  #           misc {
  #             enable_swallow = true
  #             swallow_regex = ^(kitty)|(Alacritty)$
  #           }

  #         '';
  #     };
}
