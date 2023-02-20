{ config, pkgs, lib, ... }: let 

  rust = (pkgs.rustChannelOf { channel = "nightly"; }).rust.override {
    targets = [ "x86_64-unknown-linux-gnu" ];
  };

  in {
  users.users.sargo = {
    isNormalUser = true;
    initialHashedPassword = "$6$Z7Ty/RzwsUJtd43I$6dCbqpYN1HOhTr5EoEgu6XyctK8lCYu6OqJGzREOjR5L0i6mn12vl2wF.nJzrAxqTCIl5idftqSOPI8WLNVky0";
    description = "Oliver Sargison";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = [
      pkgs.inlyne
      pkgs.feh
      pkgs.zathura
      pkgs.galculator
      pkgs.socat
      pkgs.networkmanagerapplet
      pkgs.blueman
      pkgs.pcmanfm
      pkgs.blueberry
      pkgs.jq
      pkgs.jaq
      pkgs.gojq
      pkgs.chafa
      pkgs.hyprpaper
      pkgs.htop
      pkgs.wlogout
      pkgs.ispell
      pkgs.cmake
      pkgs.gnumake
      pkgs.libreoffice
      pkgs.keepassxc
      pkgs.firefox
      pkgs.nil
      pkgs.delta
      pkgs.clang
      pkgs.mold
      pkgs.felix-fm
      pkgs.trash-cli
      pkgs.fish
      pkgs.kitty
      pkgs.protobuf
      pkgs.xplr
      pkgs.fzf
      pkgs.ripgrep
      pkgs.wl-clipboard
      pkgs.wofi
      pkgs.xclip
      pkgs.wget
      pkgs.btop
      pkgs.python310Packages.python-lsp-server
      pkgs.python310
      pkgs.unstable.armcord
      pkgs.exa
      pkgs.sd
      pkgs.zoxide
      pkgs.starship
      rust
    ];
  };
     
  home-manager.users.sargo = { pkgs, lib, ... }: let
    unstableTarball = fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
    flake-compat = builtins.fetchTarball "https://github.com/edolstra/flake-compat/archive/master.tar.gz";
    hyprland = (import flake-compat {
      src = builtins.fetchTarball "https://github.com/hyprwm/Hyprland/archive/master.tar.gz";
    }).defaultNix;
  in  {


  
    imports = [
      hyprland.homeManagerModules.default
    ];

    nixpkgs.overlays = [
      (self: super: {
        waybar = super.waybar.overrideAttrs (oldAttrs: {
          mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
        });
      })
    ];
    nixpkgs.config = {
      gtk = {
        enable = true;
        theme = {
          name = "Catppuccin-Purple-Dark";
          package = pkgs.catppuccin-gtk.override {
            accents = ["pink"];
            variant = "macchiato";
            };
          };
        };
        packageOverrides = pkgs: {
        unstable = import unstableTarball {
          config = config.nixpkgs.config;
        };
      };
    };
    home.username = "sargo";
    home.homeDirectory = "/home/sargo";
    home.stateVersion = "22.11";
    wayland.windowManager.hyprland = {
      enable = true;
      extraConfig = /*kdl*/ ''
        # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
        bind = SUPER, R, exec, fish -c rebuild
        bind = SUPER, Return, exec, projects/new-terminal-hyprland/target/release/new-terminal-hyprland
        bind = SUPER, C, exec, fish -c open_system
        bind = SUPER, Q, killactive, 
        bind = SUPERSHIFT, F, exec, pcmanfm
        bind = SUPERSFT, Space, togglefloating, 
        bind = SUPERSHIFT, Return, exec, wofi --show drun
        bind = SUPER, P, pseudo, # dwindle
        bind = SUPER, W, exec, firefox
        bind = SUPER, F,fullscreen,0
        bind = SUPERSHIFT, Q, exec, wlogout
        bind = SUPER, B, exec, blueberry
        bind = SUPERSHIFT, W, exec, nm-connection-editor
        bind = SUPERSHIFT, Z, exec, kitty fish '-c zn'
        bind = SUPER, J, layoutmsg, cyclenext
        bind = SUPER, K, layoutmsg, cycleprev 
        bind = SUPERSHIFT, J, layoutmsg, swapnext
        bind = SUPERSHIFT, K, layoutmsg, swapprev 
        bind = SUPER SHIFT, w, workspace, browser
        bind = SUPER, V, layoutmsg, focusmaster
        bind = SUPER, Space, layoutmsg, swapwithmaster
        bind = SUPER, G, exec, firefox https://grammar.net.nz/login/
        bind = SUPER, p, exec, firefox https://search.nixos.org/packages?channel=22.11&query=
        bind = ,XF86AudioLowerVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ -5% 	
        bind = ,XF86AudioRaiseVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ +5%
        bind = ,XF86AudioMute, exec, pactl set-sink-volume @DEFAULT_SINK@ 0% 	
        bind = ,XF86Calculator, exec, galculator 	
        bind = ,XF86Mail, exec, firefox https://mail.google.com/mail/u/0/#inbox
        bind = SUPER, 1, workspace, 1
        bind = SUPER, 2, workspace, 2
        bind = SUPER, 3, workspace, 3
        bind = SUPER, 4, workspace, 4
        bind = SUPER, 5, workspace, 5
        bind = SUPER, 6, workspace, 6
        bind = SUPER, 7, workspace, 7
        bind = SUPER, 8, workspace, 8
        bind = SUPER, 9, workspace, 9
        bind = SUPER, 0, workspace, 10
        bind = SUPER SHIFT, 1, movetoworkspace, 1
        bind = SUPER SHIFT, 2, movetoworkspace, 2
        bind = SUPER SHIFT, 3, movetoworkspace, 3
        bind = SUPER SHIFT, 4, movetoworkspace, 4
        bind = SUPER SHIFT, 5, movetoworkspace, 5
        bind = SUPER SHIFT, 6, movetoworkspace, 6
        bind = SUPER SHIFT, 7, movetoworkspace, 7
        bind = SUPER SHIFT, 8, movetoworkspace, 8
        bind = SUPER SHIFT, 9, movetoworkspace, 9
        bind = SUPER SHIFT, 0, movetoworkspace, 10
        bind=SUPER_SHIFT,S,movetoworkspace,special
        bind=SUPER,S,togglespecialworkspace,
        bind = SUPER, mouse_down, workspace, e+1
        bind = SUPER, mouse_up, workspace, e-1
        bindm = SUPER, mouse:272, movewindow
        bindm = SUPER, mouse:273, resizewindow
        monitor=,preferred,auto,auto
        workspace=HDMI-1,1
        exec = pkill hyprpaper ; pkill waybar ; waybar & hyprpaper & disown
        input {
            kb_layout = us
            # kb_variant = colemak
            kb_options=caps:escape
            repeat_rate=69
            repeat_delay=150
            follow_mouse = 1
            touchpad {
                natural_scroll = no
            }
            sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
        }
        general {
            gaps_in = 5
            gaps_out = 20
            border_size = 2
            col.active_border = rgb(b8bb26) 
            col.inactive_border = rgb(928374)
            layout = master
        }
        decoration {
            screen_shader = ~/.config/hypr/shader.glsl
            rounding = 10
            blur = yes
            blur_size = 3
            blur_passes = 1
            blur_new_optimizations = on
            drop_shadow = yes
            shadow_range = 4
            shadow_render_power = 3
            col.shadow = rgba(1a1a1eee) 
        }
        animations {
            enabled = yes
            bezier = myBezier, 0.05, 0.9, 0.1, 1.05
            animation = windows, 1, 7, default, slide
            animation = windowsOut, 1, 11, default, slide
            # animation = windowsOut, 1, 7, default, popin 80%
            animation = border, 1, 10, default
            animation = fade, 1, 7, default
            animation = workspaces, 1, 6, default
        }
        dwindle {
            pseudotile = yes # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
            preserve_split = yes # you probably want this
        }
        master {
            new_is_master = true
            new_on_top = true
        }
        gestures {
            # See https://wiki.hyprland.org/Configuring/Variables/ for more
            workspace_swipe = on
        }
        windowrule = float, ^(blueberry.py)$
        windowrule = float, ^(nm-connection-editor)$
        windowrule = float, ^(pavucontrol)$
        windowrule = float, ^(galculator)$

        misc {
          enable_swallow = true
          swallow_regex = ^(kitty)|(Alacritty)$
        }

      '';
    };
    programs = {
      home-manager.enable = true;  
      waybar = {
        enable = true;
        package = pkgs.waybar;
        settings = {
          mainbar = {
            spacing = 4;
            modules-left = [ "wlr/workspaces" ];
            modules-center = [ "clock" "custom/eye_saver"];
            modules-right = [ "idle_inhibitor" "pulseaudio" "network" "cpu" "memory" "battery" "tray"];
            "custom/eye_saver" = {
              format = "👁";
              on-click = "fish -c toggle_eye_saver";
              exec = "echo 👁";
            };
            "wlr/workspaces" = {
              format = "{icon}";
              on-click = "activate";
              sort-by-number = true;
            };
            "idle_inhibitor" = {
              format = "{icon}";
              format-icons = {
                activated = "";
                deactivated = "";
              };
             };
            "clock" = {
              tooltip-format = "<big>{ = %Y %B}</big>\n<tt><small>{calendar}</small></tt>";
              format-alt = "{ = %Y-%m-%d}";
              on-click = "gnome-calander";
            };
            "cpu" = {
              format = "{usage}% ";
              tooltip = false;
              on-click = "kitty -e htop";
            };
            "memory" = {
              format = "{}% ";
              on-click = "kitty -e htop";
            };
            "battery" = {
              states= {
                good = 95;
                warning = 30;
                critical = 1;
              };
              format = "{capacity}% {icon}";
              format-charging = "{capacity}% ";
              format-plugged = "{capacity}% ";
              format-alt = "{time} {icon}";
              format-icons = ["" "" "" "" ""];
            };
            "network" = {
              format-wifi = "{essid} ({signalStrength}%) ";
              format-ethernet = "{ipaddr}/{cidr} ";
              tooltip-format = "{ifname} via {gwaddr} ";
              format-linked = "{ifname} (No IP) ";
              format-disconnected = "Disconnected ⚠";
              format-alt = "{ifname} = {ipaddr}/{cidr}";
              on-click = "nm-connection-editor";
            };
            "pulseaudio" = {
              format = "{volume}% {icon} {format_source}";
              format-bluetooth = "{volume}% {icon} {format_source}";
              format-bluetooth-muted = " {icon} {format_source}";
              format-muted = " {format_source}";
              format-source = "{volume}% ";
              format-source-muted = "";
              format-icons = {
                headphone = "";
                hands-free = "";
                headset = "";
                phone = "";
                portable = "";
                car = "";
                default = ["" "" ""];
              };
              on-click = "pavucontrol";
            };
          };
        };
        style = /*css*/''
          @define-color base   #24273a;
          @define-color mantle #1e2030;
          @define-color crust  #181926;
          @define-color text     #cad3f5;
          @define-color subtext0 #a5adcb;
          @define-color subtext1 #b8c0e0;
          @define-color surface0 #363a4f;
          @define-color surface1 #494d64;
          @define-color surface2 #5b6078;
          @define-color overlay0 #6e738d;
          @define-color overlay1 #8087a2;
          @define-color overlay2 #939ab7;
          @define-color blue      #8aadf4;
          @define-color lavender  #b7bdf8;
          @define-color sapphire  #7dc4e4;
          @define-color sky       #91d7e3;
          @define-color teal      #8bd5ca;
          @define-color green     #a6da95;
          @define-color yellow    #eed49f;
          @define-color peach     #f5a97f;
          @define-color maroon    #ee99a0;
          @define-color red       #ed8796;
          @define-color mauve     #c6a0f6;
          @define-color pink      #f5bde6;
          @define-color flamingo  #f0c6c6;
          @define-color rosewater #f4dbd6;
          * {
              /* `otf-font-awesome` is required to be installed for icons */
              font-family: JetBrainsMono;
              font-size: 15px;
          }
          window#waybar {
            background: transparent;
            border-radius: 0.5rem;
            padding-top: 60px;
            margin-top: 60px;
          }
          #workspaces {
            border-radius: 1rem;
            background-color: @surface0;
            margin-top: 1rem;
            margin: 7px 3px 0px 7px;
          }
          #workspaces button {
            color: @pink;
            border-radius: 1rem;
            padding-left: 6px;
            margin: 5px 0;
            box-shadow: inset 0 -3px transparent;
            transition: all 0.5s cubic-bezier(.55,-0.68,.48,1.68);
            background-color: transparent;
          }
          #workspaces button.active {
            color: @flamingo;
            border-radius: 1rem;
          }
          #workspaces button:hover {
            color: @rosewater;
            border-radius: 1rem;
          }
          #cpu,
          #memory,
          #label
          #window
          #tray,
          #network,
          #backlight,
          #clock,
          #battery,
          #idle_inhibitor,
          #pulseaudio,
          #custom-lock,
          #custom-power {
            background-color: @surface0;
            margin: 7px 3px 0px 7px;
            padding: 10px 5px 10px 5px;
            border-radius: 1rem;
          }

          #clock {
            color: @lavender;
          }
          #battery {
            color: @green;
          }
          #battery.charging {
            color: @green;
          }
          #battery.warning:not(.charging) {
            color: @red;
          }
          #network {
              color: @flamingo;
          }
          #backlight {
            color: @yellow;
          }
          #pulseaudio {
            color: @pink;
          }
          #pulseaudio.muted {
              color: @red;
          }
          #custom-power {
              border-radius: 1rem;
              color: @red;
              margin-bottom: 1rem;
          }
          #tray {
            border-radius: 1rem;
          }
          tooltip {
              background: @base;
              border: 1px solid @pink;
          }
          tooltip label {
              color: @text;
          }
        '';
      };

      alacritty = {
        enable = true;
        settings = {
          colors = {
            primary = {
              background =  "#24273A"; # base
              foreground =  "#CAD3F5"; # text
              # Bright and dim foreground colors
              dim_foreground =  "#CAD3F5"; # text
              bright_foreground =  "#CAD3F5"; # text
            };
                    # Cursor colors
            cursor = {
              text =  "#24273A"; # base
              cursor =  "#F4DBD6"; # rosewater
            };
            vi_mode_cursor = {
              text =  "#24273A"; # base
              cursor =  "#B7BDF8"; # lavender
            };
                    # Search colors
            search = {
              matches = {
                foreground =  "#24273A"; # base
                background =  "#A5ADCB"; # subtext0
              };
              focused_match = {
                foreground =  "#24273A"; # base
                background =  "#A6DA95"; # green
              };
              footer_bar = {
                foreground =  "#24273A"; # base
                background =  "#A5ADCB"; # subtext0
              };
            };
                    # Keyboard regex hints
            hints = {
              start = {
                foreground =  "#24273A"; # base
                background =  "#EED49F"; # yellow
              };
              end = {
                foreground =  "#24273A"; # base
                background =  "#A5ADCB"; # subtext0
              };
            };
                    # Selection colors
            selection = {
              text =  "#24273A"; # base
                background =  "#F4DBD6"; # rosewater
            };
                    # Normal colors
            normal = {
              black =  "#494D64"; # surface1
                red =  "#ED8796"; # red
                green =  "#A6DA95"; # green
                yellow =  "#EED49F"; # yellow
                blue =  "#8AADF4"; # blue
                magenta =  "#F5BDE6"; # pink
                cyan =  "#8BD5CA"; # teal
                white =  "#B8C0E0"; # subtext1
            };
                    # Bright colors
            bright = {
              black =  "#5B6078"; # surface2
                red =  "#ED8796"; # red
                green =  "#A6DA95"; # green
                yellow =  "#EED49F"; # yellow
                blue =  "#8AADF4"; # blue
                magenta =  "#F5BDE6"; # pink
                cyan =  "#8BD5CA"; # teal
                white =  "#A5ADCB"; # subtext0
            };
                    # Dim colors
            dim = {
              black =  "#494D64"; # surface1
                red =  "#ED8796"; # red
                green =  "#A6DA95"; # green
                yellow =  "#EED49F"; # yellow
                blue =  "#8AADF4"; # blue
                magenta =  "#F5BDE6"; # pink
                cyan =  "#8BD5CA"; # teal
                white =  "#B8C0E0"; # subtext1
            };
          };
        };
      };
      lf = {
        enable = true;
        settings = {
          dircounts = true;
          dirfirst = true;
          drawbox = true;
          icons = true;
        };
        extraConfig = ''set previewer 'bat --color=always $1' '';
      };
      bat = {
        enable = true;
        config = { theme = "gruvbox-dark"; };
      };
      lazygit = {
        enable = true;
        settings = {
          git =  {  
            autofetch = true;
            paging = {
              colorarg = "always";
              colorArg = "always";
              pager = /*bash*/ "delta --dark --paging=never --24-bit-color=never";
            };
          };
        };
      };
      helix = {
        enable = true;
        package = pkgs.unstable.helix;
        # package = pkgs.helix_bleeding;
        settings = {
          theme = "gruvbox";
          editor = {
            line-number = "relative";
            scrolloff = 10;
            cursorline = true;
            auto-save = true;
            cursor-shape = {
              insert = "bar";
              normal = "block";
            };
            lsp.display-messages = true;
            indent-guides = {
              render = true;
              character = "│";
            };
          };
          keys = { };
        };
      };
      kitty = {
        enable = true;
        theme  = "Gruvbox Dark";
        settings = {
            font_family = "JetbrainsMono";
            update_check_interval   = 0;
            hide_window_decorations = "yes";
            resize_in_steps         = "yes";
            confirm_os_window_close = 0;
            remember_window_size    = "yes";
            background_opacity      = "0.85";
            allow_remote_control    = "yes";
        };
      };

      starship = {
        enable = true;
        settings = {
          "$schema" = "https://starship.rs/config-schema.json";
        };
      };
      
      fish = {
        enable = true;
        functions = {
          rebuild = {
            body = ''sudo cp /home/sargo/nix-files/*.nix /etc/nixos/ && sudo nixos-rebuild switch '';
            description = "Rebuild the system configuration";
          };
          toggle_eye_saver = {
            body = /*fish*/''
            switch "$(hyprctl getoption decoration:screen_shader)"
              case "*shader.glsl*" 
                  hyprctl keyword decoration:screen_shader ~/.config/hypr/shader_eye_saver.glsl
              case '*'
                  hyprctl keyword decoration:screen_shader ~/.config/hypr/shader.glsl
              end
               '';
            description = ''Toggle the eye saver shader'';
          };
          open_system = {
            body = /*fish*/  ''
              ~/projects/open_system/target/release/hyprtest
            '';
            description = ''Goto the session or open it'';
          };
          dmenu = {
            body = /*fish*/''
                wofi --show dmenu 
            '';
            description = "Dmenu for wayland or x using wofi or rofi";
          };
          copy_history = {
            body = /*fish*/''history | fzf | xc'';
            description = ''Copy a previously run command'';
          };
        };
        shellAliases = {
           xc  = "wl-copy";
        };
        shellAbbrs = {
          hxb = "~/.cargo/bin/hx --config ~/.config/helix/bleeding_config.toml";
           i  = "nix-env -iA nixos.";
           q  = "exit";
         ":q" = "exit";
           c  = "clear";
           ls = "exa -l";
           r  = "reset";
          xplr = "cd $(/usr/bin/env xplr)";
          ns = "nix-shell";
        };
        shellInit = /*fish*/''
          export EDITOR="hx"
          export VISUAL="hx"
          export BROWSER="firefox"
        '';
        interactiveShellInit = /*fish*/
        ''
            set fish_greeting
            bind \ce edit_command_buffer
            bind \ch copy_history  
            zoxide init fish | source
            starship init fish | source
            set -Ux STARSHIP_LOG error
            any-nix-shell fish --info-right | source
        '';
        # NOTE don't use plugins from the nixpkgs repo as they aren't configured properly
        plugins = [
            {
              name = "autopair-fish";
              src = pkgs.fetchFromGitHub {
                owner = "jorgebucaran";
                repo = "autopair.fish";
                rev = "4d1752ff5b39819ab58d7337c69220342e9de0e2";
                sha256 = "qt3t1iKRRNuiLWiVoiAYOu+9E7jsyECyIqZJ/oRIT1A=";
              };          
            }{
              name = "colored-man-pages";
              src = pkgs.fetchFromGitHub {
                owner = "PatrickF1";
                repo = "colored_man_pages.fish";
                rev = "f885c2507128b70d6c41b043070a8f399988bc7a";
                sha256 = "ii9gdBPlC1/P1N9xJzqomrkyDqIdTg+iCg0mwNVq2EU=";
              };          
            }{
              name = "sponge";
              src = pkgs.fetchFromGitHub {
                owner = "meaningful-ooo";
                repo = "sponge";
                rev = "384299545104d5256648cee9d8b117aaa9a6d7be";
                sha256 = "MdcZUDRtNJdiyo2l9o5ma7nAX84xEJbGFhAVhK+Zm1w=";
              };          
            }
        ];
      };
      git = {
        enable = true;
        userName = "Oliver Sargison";
        userEmail = "sargo@sargo.cc";
        delta.enable = true;
      };
      bash = {

        enable = true;
      };
    };
    dconf.settings = {
   
      "org/gnome/desktop/interface" = {
        gtk-theme = "gruvbox-dark";
        icon-theme=  "oomox-gruvbox-dark";
      };
  
      "org/gnome/settings-daemon/plugins/media-keys" = {
        custom-keybindings = [
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
        ];
      };
      "org/gnome/desktop/wm/keybindings" = {
          switch-to-workspace-1 = ["<Shift><Super>1"]; switch-to-workspace-2 = ["<Shift><Super>2"]; switch-to-workspace-3 = ["<Shift><Super>3"]; switch-to-workspace-4 = ["<Shift><Super>4"]; switch-to-workspace-5 = ["<Shift><Super>5"]; switch-to-workspace-6 = ["<Shift><Super>6"]; switch-to-workspace-7 = ["<Shift><Super>7"]; switch-to-workspace-8 = ["<Shift><Super>8"]; switch-to-workspace-9 = ["<Shift><Super>9"]; 
          move-to-workspace-1 = ["<Control><Super>1"]; move-to-workspace-2 = ["<Control><Super>2"]; move-to-workspace-3 = ["<Control><Super>3"]; move-to-workspace-4 = ["<Control><Super>4"]; move-to-workspace-5 = ["<Control><Super>5"]; move-to-workspace-6 = ["<Control><Super>6"]; move-to-workspace-7 = ["<Control><Super>7"]; move-to-workspace-8 = ["<Control><Super>8"]; move-to-workspace-9 = ["<Control><Super>9"]; switch-applications   = ["<Super>Tab"];
          switch-applications-backward = ["<Super><Shift>Tab"];
          switch-windows = ["<Alt>Tab"];
          switch-windows-backward = ["<Alt><Shift>Tab"];
          toggle-fullscreen = ["<Alt>F11"];
          close = ["<Super>q"];
      };
  
      "org/gnome/shell" = { 
        enabled-exensions = [
          "apps-menu@gnome-shell-extensions.gcampax.github.com" "auto-move-windows@gnome-shell-extensions.gcampax.github.com" "places-menu@gnome-shell-extensions.gcampax.github.com" "drive-menu@gnome-shell-extensions.gcampax.github.com" "user-theme@gnome-shell-extensions.gcampax.github.com" "blur-my-shell@aunetx" "color-picker@tuberry" "pano@elhan.io" "dash-to-dock@micxgx.gmail.com" "custom-accent-colors@demiskp" "windowsNavigator@gnome-shell-extensions.gcampax.github.com" "gnome-fuzzy-app-search@gnome-shell-extensions.Czarlie.gitlab.com" "caffeine@patapon.info" "uptime-indicator@gniourfgniourf.gmail.com" 
        ];
        favorite-apps = [
          "firefox.desktop" "kitty.desktop" "armcord.desktop" "org.keepassxc.KeePassXC.desktop" "org.gnome.Nautilus.desktop"
        ];
      };
      "org/gnome/shell/custom-accent-colors/theme-shell" = {
        accent-color = "red"; theme-flatpak = true; theme-gtk3 = true; theme-shell = true;
      };
      "org/gnome/shell/extensions/blur-my-shell" = {
        hacks-level = 0; sigma = 200; brightness = 1;
      };
      "org/gnome/shell/extensions/auto-move-windows" = {
        applications-list = [       
         "firefox.desktop:1" "kitty.desktop:2" "org.keepassxc.KeePassXC.desktop:4" "armcord.desktop:3"        
        ];
      };

      "org/gnome/shell/extensions/dash-to-dock" = {
        animation-time=0.10000000000000002; apply-custom-theme=false; background-color="rgb(30,30,30)"; background-opacity=0.69999999999999996; click-action="focus-minimize-or-previews"; custom-background-color=true; custom-theme-shrink=false; dash-max-icon-size=48; dock-position="LEFT"; height-fraction=0.73999999999999999; hide-delay=0.10000000000000002; hot-keys=true; hotkeys-overlay=true; hotkeys-show-dock=true; intellihide-mode="FOCUS_APPLICATION_WINDOWS"; multi-monitor=false; preferred-monitor=-2; preferred-monitor-by-connector="HDMI-1"; preview-size-scale=0.32000000000000001; scroll-action="cycle-windows"; shortcut-timeout=2.0; transparency-mode="FIXED";
      };
       "org/gnome/desktop/peripherals/keyboard" = {
         delay = lib.hm.gvariant.mkUint32 175; repeat-interval = lib.hm.gvariant.mkUint32 18; repeat = true;
       };
    };
 
    
    # home.file.".cargo/config.toml".text = /*toml*/ ''

    #   [target.x86_64-unknown-linux-gnu]
    #   linker = "clang"
    #   rustflags = ["-C", "link-arg=-fuse-ld=${pkgs.mold}/bin/mold"]
    # '';

    home.file.".config/hypr/hyprpaper.conf".text = /*toml*/  '' 
      preload = ~/nix-files/gruv-material-texture.png

      wallpaper = HDMI-A-1,~/nix-files/gruv-material-texture.png
      wallpaper = eDP-1,~/nix-files/gruv-material-texture.png
    '';


    home.file.".config/wofi/style.css".text = /*css*/''
      @define-color base   #24273a; @define-color mantle #1e2030; @define-color crust  #181926;  @define-color text     #cad3f5; @define-color subtext0 #a5adcb; @define-color subtext1 #b8c0e0;  @define-color surface0 #363a4f; @define-color surface1 #494d64; @define-color surface2 #5b6078;  @define-color overlay0 #6e738d; @define-color overlay1 #8087a2; @define-color overlay2 #939ab7;  @define-color blue      #8aadf4; @define-color lavender  #b7bdf8; @define-color sapphire  #7dc4e4; @define-color sky       #91d7e3; @define-color teal      #8bd5ca; @define-color green     #a6da95; @define-color yellow    #eed49f; @define-color peach     #f5a97f; @define-color maroon    #ee99a0; @define-color red       #ed8796; @define-color mauve     #c6a0f6; @define-color pink      #f5bde6; @define-color flamingo  #f0c6c6; @define-color rosewater #f4dbd6;  window { margin: 0px; border-radius: 30px; border: 2px solid teal; }  #input { margin: 5px; border: none; border-radius: 30px; }  #inner-box { margin: 5px; border: none; border-radius: 30px; }  #outer-box { margin: 15px; border: none; }  #scroll { margin: 0px; border: none; }  #text { margin: 5px; border: none; }   #entry:selected { border-radius: 20px; outline: none; }  #entry:selected * { border-radius: 20px; outline: none; } 
    ''; 

  };
}

