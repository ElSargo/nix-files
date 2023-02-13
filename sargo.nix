{ config, pkgs, lib, ... }: {
    home-manager.users.sargo = { pkgs, lib, ... }: let
    unstableTarball = fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
    flake-compat = builtins.fetchTarball "https://github.com/edolstra/flake-compat/archive/master.tar.gz";
    hyprland = (import flake-compat {
      src = builtins.fetchTarball "https://github.com/hyprwm/Hyprland/archive/master.tar.gz";
    }).defaultNix;
  in  {


  users.users.sargo = {
    isNormalUser = true;
    initialHashedPassword = "$6$Z7Ty/RzwsUJtd43I$6dCbqpYN1HOhTr5EoEgu6XyctK8lCYu6OqJGzREOjR5L0i6mn12vl2wF.nJzrAxqTCIl5idftqSOPI8WLNVky0";
    description = "Oliver Sargison";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs;[
      feh
      zathura
      rust-script
      galculator
      socat
      networkmanagerapplet
      blueman
      pcmanfm
      blueberry
      jq
      jaq
      gojq
      chafa
      hyprpaper
      htop
      wlogout
      ispell
      cmake
      gnumake
      libreoffice
      keepassxc
      firefox
      unstable.zellij
      nil
      delta
      clang
      mold
      felix-fm
      trash-cli
      fish
      kitty
      protobuf
      xplr
      fzf
      ripgrep
      wl-clipboard
      wofi
      xclip
      wget
      btop
      python310Packages.python-lsp-server
      python310
      unstable.armcord
      unstable.rustc
      unstable.cargo
      unstable.rust-analyzer
      unstable.clippy
      unstable.rustfmt
      exa
      sd
      zoxide
      starship
    ];
  };
  

  
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
        bind = SUPER, Return, exec, projects/open_terminal/target/release/open_terminal
        bind = SUPER, C, exec, fish -c open_system
        bind = SUPER, Q, killactive, 
        bind = SUPER, M, exit, 
        bind = SUPER, E, exec, nautilus
        bind = SUPERSHIFT, Space, togglefloating, 
        bind = SUPERSHIFT, Return, exec, wofi --show drun
        bind = SUPER, P, pseudo, # dwindle
        bind = SUPER, W, exec, firefox
        bind = SUPER, F,fullscreen,0
        bind = SUPERSHIFT, Q, exec, wlogout
        bind = SUPER, B, exec, blueberry
        bind = SUPERSHIFT, W, exec, nm-connection-editor
        bind = SUPER, Z, exec, fish -c 'set ses $(zellij list-sessions | wofi --show dmenu) ; kitty zellij a $ses'
        bind = SUPERSHIFT, Z, exec, kitty fish '-c zn'
        bind = SUPER, J, layoutmsg, cyclenext
        bind = SUPER, K, layoutmsg, cycleprev 
        bind = SUPERSHIFT, J, layoutmsg, swapnext
        bind = SUPERSHIFT, K, layoutmsg, swapprev 
        bind = SUPER SHIFT, w, workspace, browser
        bind = SUPER, V, layoutmsg, focusmaster
        bind = SUPER, Space, layoutmsg, swapwithmaster
        bind = SUPER, G, exec, firefox https://grammar.net.nz/login/
        bind = SUPER, p, exec, firefox https:https://search.nixos.org/packages?channel=22.11&query=
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
            col.active_border = rgb(8bd5ca) rgb(a6da95) 145deg
            col.inactive_border = rgba(595959aa)
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
            col.shadow = rgba(1a1a1aee) 
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
              on-click = "alacritty -e htop";
            };
            "memory" = {
              format = "{}% ";
              on-click = "alacritty -e htop";
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
        settings = {
          theme = "catppuccin_macchiato";
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
          keys.normal = {
            X = '':sh zellij action write-chars "gsvgl" '';
            "C-j" = ['':sh zellij action write-chars 'f(lmi(' '' ''flip_selections''];
            "C-k" = ['':sh zellij action write-chars 'f[lmi[' '' ''flip_selections''];
            "C-l" = ['':sh zellij action write-chars 'f{lmi{' '' ''flip_selections''];
          };
        };
      };
      kitty = {
        enable = true;
        theme  = "Catppuccin-Macchiato";
        settings = {
            font_family = "JetbrainsMono";
            update_check_interval   = 0;
            hide_window_decorations = "yes";
            resize_in_steps         = "yes";
            confirm_os_window_close = 0;
            remember_window_size    = "yes";
            background_opacity      = "1.0";
            allow_remote_control    = "yes";
        };
      };
      fish = {
        enable = true;
        functions = {
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
              rust-script -d 'hyprland=*' -e 'let clients = <hyprland::data::Clients as hyprland::shared::HyprData>::get()?; for client in clients { if client.title.starts_with("Zellij (system)") { if let Err(e) = hyprland::dispatch::Dispatch::call(hyprland::dispatch::DispatchType::Workspace( hyprland::dispatch::WorkspaceIdentifierWithSpecial::Id(client.workspace.id), )) { println!("Error: {e}"); } return Ok(()); } } std::process::Command::new("kitty") .arg("--title") .arg("Zellij (system)") .arg("zellij") .arg("a") .arg("system") .spawn() .expect("Unable to spawn command");'            
            '';
            description = ''Goto the session or open it'';
          };
          zr = {
            body = /*fish*/''zellij run --name "$argv" -- fish -c "$argv" '';
            description = ''Run a command in a zellij pane'';
          };
          zrf = {
            body = /*fish*/''zellij run --name "$argv" --floating -- fish -c "$argv" '';
            description = ''Run a command in a floating zellij pane'';
          };
          ze = {
            body = /*fish*/''zellij edit $argv '';
            description = ''Edit a file with helix in zellij'';
          };
          zef = {
            body = /*fish*/''zellij edit --floating $argv '';
            description = ''Edit a file with helix in a floating zellij pane'';
          };
          o = {
            body = /*fish*/''zellij a $name || zellij -l /home/sargo/.config/zellij/layouts/$name -s $name'';
            description = '' '';
            argumentNames = ["name"];
          };
          dmenu = {
            body = /*fish*/''
              switch $XDG_SESSION_TYPE
              case "*wayland*"
                wofi --show dmenu 
              case "*"
                rofi --show dmenu 
              end
            '';
            description = "Dmenu for wayland or x using wofi or rofi";
          };
          zd = {
            body = /*fish*/''fish -c 'fish -c 'pkill kitty ; kitty zellij a "$(zellij list-sessions | dmenu)" '';
            description = ''Open a menu active zellij sessions'';
          
          };
          zn = {
            body = /*fish*/''set SESSION_SEL $(string trim --right --chars='.kdl' "$(/usr/bin/env ls ~/.config/zellij/layouts | dmenu)") ; zellij a $SESSION_SEL || zellij -s $SESSION_SEL -l $SESSION_SEL  '';
            description = "Open a prompt with prebuilt layouts and join or spwan a session with it";
          };          
          fo = {
            body = /*fish*/''fish -c 'set name $(zellij list-sessions | fzf);zellij a $name || zellij -l /home/sargo/.config/zellij/layouts/$1 -s $name' '';
            description = ''Open a fuzzy finder of active zellij sessions'';
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
        gtk-theme = "Catppuccin-Dark";
      };
  
      "org/gnome/settings-daemon/plugins/media-keys" = {
        custom-keybindings = [
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
        ];
      };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
        binding = "<Super>n";
        command = /*fish*/''fish -c 'pkill kitty ; kitty fish -c zn' '';
        name = "Zellij from layout";
      };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
        binding = "<Super><Shift>n";
        command = /*fish*/''fish -c 'pkill kitty ; kitty zellij -s $(echo "" | dmenu) ' '';
        name = "New zellij";
      };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
        binding = "<Super>j";
        command = /*fish*/''
          fish -c '
            pkill kitty;
            set NAME $(zellij list-sessions | dmenu)
            set NAME $(string split " " -- $NAME)[1]
            kitty zellij a $NAME
          '
        '';
        name = "Zellij attach";
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
    home.file.".cargo/config.toml".text = /*toml*/ ''
      [target.x86_64-unknown-linux-gnu]
      linker = "clang"
      rustflags = ["-C", "link-arg=-fuse-ld=${pkgs.mold}/bin/mold"]
    '';
 
    home.file.".config/wofi/style.css".text = /*css*/''
      @define-color base   #24273a; @define-color mantle #1e2030; @define-color crust  #181926;  @define-color text     #cad3f5; @define-color subtext0 #a5adcb; @define-color subtext1 #b8c0e0;  @define-color surface0 #363a4f; @define-color surface1 #494d64; @define-color surface2 #5b6078;  @define-color overlay0 #6e738d; @define-color overlay1 #8087a2; @define-color overlay2 #939ab7;  @define-color blue      #8aadf4; @define-color lavender  #b7bdf8; @define-color sapphire  #7dc4e4; @define-color sky       #91d7e3; @define-color teal      #8bd5ca; @define-color green     #a6da95; @define-color yellow    #eed49f; @define-color peach     #f5a97f; @define-color maroon    #ee99a0; @define-color red       #ed8796; @define-color mauve     #c6a0f6; @define-color pink      #f5bde6; @define-color flamingo  #f0c6c6; @define-color rosewater #f4dbd6;  window { margin: 0px; border-radius: 30px; border: 2px solid teal; }  #input { margin: 5px; border: none; border-radius: 30px; }  #inner-box { margin: 5px; border: none; border-radius: 30px; }  #outer-box { margin: 15px; border: none; }  #scroll { margin: 0px; border: none; }  #text { margin: 5px; border: none; }   #entry:selected { border-radius: 20px; outline: none; }  #entry:selected * { border-radius: 20px; outline: none; } 
    ''; 
    home.file.".config/zellij/config.kdl".text = /*kdl*/ ''
      // If you'd like to override the default keybindings completely, be sure to change "keybinds" to "keybinds clear-defaults=true"
      keybinds clear-defaults=true{
          normal {
              // uncomment this and adjust key if using copy_on_select=false
              // bind "Alt c" { Copy; }
              bind "Alt Right" { GoToNextTab; }
              bind "Alt Left" { GoToPreviousTab; }
              bind "Alt k" { FocusNextPane; }
              bind "Alt k" { FocusNextPane; }
              bind "Alt j" { FocusPreviousPane; }
              bind "Alt 1" { GoToTab 1; }
              bind "Alt 2" { GoToTab 2; }
              bind "Alt 3" { GoToTab 3; }
              bind "Alt 4" { GoToTab 4; }
              bind "Alt 5" { GoToTab 5; }
              bind "Alt 6" { GoToTab 6; }
              bind "Alt 7" { GoToTab 7; }
              bind "Alt 8" { GoToTab 8; }
              bind "Alt 9" { GoToTab 9; }
              bind "Alt f" {ToggleFloatingPanes; }
          }
          locked {
              bind "Ctrl g" { SwitchToMode "Normal"; }
          }
          resize {
              bind "Ctrl n" { SwitchToMode "Normal"; }
              bind "h" "Left" { Resize "Increase Left"; }
              bind "j" "Down" { Resize "Increase Down"; }
              bind "k" "Up"   { Resize "Increase Up"; }
              bind "l" "Right"{ Resize "Increase Right"; }
              bind "H" { Resize "Decrease Left"; }
              bind "J" { Resize "Decrease Down"; }
              bind "K" { Resize "Decrease Up"; }
              bind "L" { Resize "Decrease Right"; }
              bind "=" "+" { Resize "Increase"; }
              bind "-" { Resize "Decrease"; }
          }
          pane {
              bind "Ctrl p" { SwitchToMode "Normal"; }
              bind "h" "Left" { MoveFocus "Left"; }
              bind "l" "Right" { MoveFocus "Right"; }
              bind "j" "Down" { MoveFocus "Down"; }
              bind "k" "Up" { MoveFocus "Up"; }
              bind "p" { SwitchFocus; }
              bind "n" { NewPane; SwitchToMode "Normal"; }
              bind "d" { NewPane "Down"; SwitchToMode "Normal"; }
              bind "r" { NewPane "Right"; SwitchToMode "Normal"; }
              bind "x" { CloseFocus; SwitchToMode "Normal"; }
              bind "f" { ToggleFocusFullscreen; SwitchToMode "Normal"; }
              bind "z" { TogglePaneFrames; SwitchToMode "Normal"; }
              bind "w" { ToggleFloatingPanes; SwitchToMode "Normal"; }
              bind "e" { TogglePaneEmbedOrFloating; SwitchToMode "Normal"; }
              bind "c" { SwitchToMode "RenamePane"; PaneNameInput 0;}
          }
          move {
              bind "Ctrl h" { SwitchToMode "Normal"; }
              bind "n" "Tab" { MovePane; }
              bind "h" "Left" { MovePane "Left"; }
              bind "j" "Down" { MovePane "Down"; }
              bind "k" "Up" { MovePane "Up"; }
              bind "l" "Right" { MovePane "Right"; }
          }
          tab {
              bind "Ctrl t" { SwitchToMode "Normal"; }
              bind "r" { SwitchToMode "RenameTab"; TabNameInput 0; }
              bind "h" "Left" "Up" "k" { GoToPreviousTab; }
              bind "l" "Right" "Down" "j" { GoToNextTab; }
              bind "n" { NewTab; SwitchToMode "Normal"; }
              bind "x" { CloseTab; SwitchToMode "Normal"; }
              bind "s" { ToggleActiveSyncTab; SwitchToMode "Normal"; }
              bind "1" { GoToTab 1; SwitchToMode "Normal"; }
              bind "2" { GoToTab 2; SwitchToMode "Normal"; }
              bind "3" { GoToTab 3; SwitchToMode "Normal"; }
              bind "4" { GoToTab 4; SwitchToMode "Normal"; }
              bind "5" { GoToTab 5; SwitchToMode "Normal"; }
              bind "6" { GoToTab 6; SwitchToMode "Normal"; }
              bind "7" { GoToTab 7; SwitchToMode "Normal"; }
              bind "8" { GoToTab 8; SwitchToMode "Normal"; }
              bind "9" { GoToTab 9; SwitchToMode "Normal"; }
              bind "Tab" { ToggleTab; }
          }
          scroll {
              bind "Ctrl f" { SwitchToMode "Normal"; }
              bind "e" { EditScrollback; SwitchToMode "Normal"; }
              bind "s" { SwitchToMode "EnterSearch"; SearchInput 0; }
              bind "Ctrl c" { ScrollToBottom; SwitchToMode "Normal"; }
              bind "j" "Down" { ScrollDown; }
              bind "k" "Up" { ScrollUp; }
              bind "Ctrl f" "PageDown" "Right" "l" { PageScrollDown; }
              bind "Ctrl b" "PageUp" "Left" "h" { PageScrollUp; }
              bind "d" { HalfPageScrollDown; }
              bind "u" { HalfPageScrollUp; }
              // uncomment this and adjust key if using copy_on_select=false
              // bind "Alt c" { Copy; }
          }
          search {
              bind "Ctrl s" { SwitchToMode "Normal"; }
              bind "Ctrl c" { ScrollToBottom; SwitchToMode "Normal"; }
              bind "j" "Down" { ScrollDown; }
              bind "k" "Up" { ScrollUp; }
              bind "Ctrl f" "PageDown" "Right" "l" { PageScrollDown; }
              bind "Ctrl b" "PageUp" "Left" "h" { PageScrollUp; }
              bind "d" { HalfPageScrollDown; }
              bind "u" { HalfPageScrollUp; }
              bind "n" { Search "down"; }
              bind "p" { Search "up"; }
              bind "c" { SearchToggleOption "CaseSensitivity"; }
              bind "w" { SearchToggleOption "Wrap"; }
              bind "o" { SearchToggleOption "WholeWord"; }
          }
          entersearch {
              bind "Ctrl c" "Esc" { SwitchToMode "Scroll"; }
              bind "Enter" { SwitchToMode "Search"; }
          }
          renametab {
              bind "Ctrl c" { SwitchToMode "Normal"; }
              bind "Esc" { UndoRenameTab; SwitchToMode "Tab"; }
          }
          renamepane {
              bind "Ctrl c" { SwitchToMode "Normal"; }
              bind "Esc" { UndoRenamePane; SwitchToMode "Pane"; }
          }
          session {
              bind "Ctrl s" { SwitchToMode "Normal"; }
              bind "Ctrl f" { SwitchToMode "Scroll"; }
              bind "d" { Detach; }
          }
          tmux {
              bind "[" { SwitchToMode "Scroll"; }
              bind "Ctrl b" { Write 2; SwitchToMode "Normal"; }
              bind "\"" { NewPane "Down"; SwitchToMode "Normal"; }
              bind "%" { NewPane "Right"; SwitchToMode "Normal"; }
              bind "z" { ToggleFocusFullscreen; SwitchToMode "Normal"; }
              bind "c" { NewTab; SwitchToMode "Normal"; }
              bind "," { SwitchToMode "RenameTab"; }
              bind "p" { GoToPreviousTab; SwitchToMode "Normal"; }
              bind "n" { GoToNextTab; SwitchToMode "Normal"; }
              bind "Left" { MoveFocus "Left"; SwitchToMode "Normal"; }
              bind "Right" { MoveFocus "Right"; SwitchToMode "Normal"; }
              bind "Down" { MoveFocus "Down"; SwitchToMode "Normal"; }
              bind "Up" { MoveFocus "Up"; SwitchToMode "Normal"; }
              bind "h" { MoveFocus "Left"; SwitchToMode "Normal"; }
              bind "l" { MoveFocus "Right"; SwitchToMode "Normal"; }
              bind "j" { MoveFocus "Down"; SwitchToMode "Normal"; }
              bind "k" { MoveFocus "Up"; SwitchToMode "Normal"; }
              bind "o" { FocusNextPane; }
              bind "d" { Detach; }
          }
          shared_except "locked" {
              bind "Ctrl g" { SwitchToMode "Locked"; }
              bind "Ctrl q" { Quit; }
              bind "Alt n" { NewPane; }
              bind "Alt h" "Alt Left" { MoveFocusOrTab "Left"; }
              bind "Alt l" "Alt Right" { MoveFocusOrTab "Right"; }
              bind "Alt j" "Alt Down" { MoveFocus "Down"; }
              bind "Alt k" "Alt Up" { MoveFocus "Up"; }
              bind "Alt =" "Alt +" { Resize "Increase"; }
              bind "Alt -" { Resize "Decrease"; }
          }
          shared_except "normal" "locked" {
              bind "Enter" "Esc" { SwitchToMode "Normal"; }
          }
          shared_except "pane" "locked" {
              bind "Ctrl p" { SwitchToMode "Pane"; }
          }
          shared_except "resize" "locked" {
              bind "Ctrl n" { SwitchToMode "Resize"; }
          }
          shared_except "scroll" "locked" {
              bind "Ctrl f" { SwitchToMode "Scroll"; }
          }
          shared_except "session" "locked" {
              bind "Ctrl s" { SwitchToMode "Session"; }
          }
          shared_except "tab" "locked" {
              bind "Ctrl t" { SwitchToMode "Tab"; }
          }
          shared_except "move" "locked" {
              bind "Ctrl h" { SwitchToMode "Move"; }
          }
          shared_except "tmux" "locked" {
              bind "Ctrl b" { SwitchToMode "Tmux"; }
          }
      }
      plugins {
          tab-bar { path "tab-bar"; }
          status-bar { path "status-bar"; }
          strider { path "strider"; }
          compact-bar { path "compact-bar"; }
      }
      // For more examples, see: https://github.com/zellij-org/zellij/tree/main/example/themes
      themes {
          dracula {
              rounded_corners: true
              fg 248 248 242
              bg 40 42 54
              red 255 85 85
              green 80 250 123
              yellow 241 250 140
              blue 98 114 164
              magenta 255 121 198
              orange 255 184 108
              cyan 139 233 253
              black 0 0 0
              white 255 255 255
          }
          gruvbox-light {
              fg 60 56 54
              bg 251 82 75
              black 40 40 40
              red 205 75 69
              green 152 151 26
              yellow 215 153 33
              blue 69 133 136
              magenta 177 98 134
              cyan 104 157 106
              white 213 196 161
              orange 214 93 14
          }
          gruvbox-dark {
              fg 213 196 161
              bg 40 40 40
              black 60 56 54
              red 204 36 29
              green 152 151 26
              yellow 215 153 33
              blue 69 133 136
              magenta 177 98 134
              cyan 104 157 106
              white 251 241 199
              orange 214 93 14
          }
          catppuccin-frappe {
            bg "#626880" // Surface2
            fg "#c6d0f5"
            red "#e78284"
            green "#a6d189"
            blue "#8caaee"
            yellow "#e5c890"
            magenta "#f4b8e4" // Pink
            orange "#ef9f76" // Peach
            cyan "#99d1db" // Sky
            black "#292c3c" // Mantle
            white "#c6d0f5"
          }
          catppuccin-macchiato {
            bg "#5b6078"  
            fg "#cad3f5"
            red "#ed8796"
            green "#a6da95"
            blue "#8aadf4"
            yellow "#eed49f"
            magenta "#f5bde6"  
            orange "#f5a97f"  
            cyan "#91d7e3"  
            black "#1e2030"  
            white "#cad3f5"
          }
      }
      theme "catppuccin-macchiato"
      # // default_layout "compact"
      ui {
          pane_frames {
              rounded_corners true
          }
      }
    
      copy_command "wl-copy" // x11
    '';

    home.file.".config/zellij/layouts/system.kdl".text = /*kdl*/ ''
      layout {
      	default_tab_template {
      		children
      		cbar
      	}
          pane_template name="cbar" {
              pane size=1 borderless=true {
                  plugin location="zellij:compact-bar"
              }
          }
          pane_template name="bar" {
              pane size=2 borderless=true {
                  plugin location="zellij:status-bar"
              }
              pane size=1 borderless=true {
                  plugin location="zellij:tab-bar"
              }
          }

          tab name="Sys conf" {
              pane split_direction="vertical" {
      			// Root commands run in user shell to avoid glitches
                  pane name="Configuration.nix" command="fish"{
                      args "-c" " sudo hx /etc/nixos/configuration.nix"
                  }
                  pane size="30%" split_direction="horizontal" {
      		        pane name="Rebuild" command="fish" start_suspended=true {
      		            args "-c" "sudo nixos-rebuild switch" 
      		        }
                  }
              }
          }        
      }
    '';
  
    home.file.".config/zellij/layouts/default.kdl".text = /*kdl*/ '' 
      layout {
          pane split_direction="vertical" {
            pane 
            pane size="10%"{
              plugin location="zellij:strider"
            }
          }
          pane size=1 borderless=true {
              plugin location="zellij:compact-bar"
          }
      }
    '';
  
    home.file.".config/zellij/layouts/mcsc.kdl".text = /*kdl*/ '' 
      layout {
        cwd "/home/sargo/projects/mcsc"
        pane_template name="cbar" {
            pane size=1 borderless=true {
                plugin location="zellij:compact-bar"
            }
        }
        pane_template name="bar" {
            pane size=2 borderless=true {
                plugin location="zellij:status-bar"
            }
            pane size=1 borderless=true {
                plugin location="zellij:tab-bar"
            }
        }
   
        // Client workspace
        tab name="Client" {
            pane split_direction="vertical" {
                pane name="Helix" command="hx"{
                    args "src/client.rs"
                }
                    pane size="30%" split_direction="horizontal" {
                    pane name="Run client" command="cargo" start_suspended=true {
                        args "run" "--bin" "mcsc-client"
                    }
                }
            }
            cbar
        }        
        // Server workspace
        tab focus=true name="Server"  {
            pane split_direction="vertical" {
                // pane name="Helix" command="pwd" focus=true 
                pane name="Helix" command="hx" focus=true {
                    args "src/server.rs" 
                }
                pane name="Run server" size="30%" command="cargo" start_suspended=true {
                    args "run" "--bin" "mcsc-server"
                }
            }
            cbar
        }
        tab name="Files" {
            pane  split_direction="vertical" {
                pane name="XPLR" command="xplr" borderless=true  {
                    args "./"
                }
        
            }
            cbar
        }
        tab name="Git" {
            pane  split_direction="vertical" {
                pane name="Lazygit" command="lazygit" borderless=true  
            }
            cbar
        }
    }
    '';
    home.file.".config/zellij/layouts/rolling-set.kdl".text = /*kdl*/ '' 
      layout {
      	cwd "/home/sargo/projects/rolling-set"
          pane split_direction="vertical" {
              pane name="Helix" command="hx"{
                  args "src/lib.rs"
              }
              pane size="35%" split_direction="horizontal" {
                  pane name="Run" command="cargo" {
                      args "test"
                  }
                  pane name="LazyGit" command="lazygit"{
              
                  }
              }
          }
          pane size=2 borderless=true {
              plugin location="zellij:status-bar"
          }
          // pane size=1 borderless=true {
          //     plugin location="zellij:tab-bar"
          // }
      
      }
    '';
    home.file.".config/zellij/layouts/unixchadbookmarks.kdl".text = /*kdl*/ ''  
      layout {
          cwd "/home/sargo/projects/unixchadbookmarks"
          pane_template name="bar" {
              pane size=2 borderless=true {
                  plugin location="zellij:status-bar"
              }
              pane size=1 borderless=true {
                  plugin location="zellij:tab-bar"
              }
          }
      
          tab name="Shell" {
              pane  split_direction="vertical" {
                  pane           
                  pane          
              }
              bar
          }
          tab name="Files" {
              pane  split_direction="vertical" {
                  pane name="LF" command="fish"{
                      args "-c" "lf"
                  }
                  pane name="Lazygit" command="lazygit"           
              }
              bar
          }
          tab focus=true name="Code"  {
              pane split_direction="vertical" {
                  // pane name="Helix" command="pwd" focus=true 
                  pane name="Helix" command="hx" focus=true {
                      args "src/main.rs" 
                  }
                  pane name="Install" size="30%" command="cargo" start_suspended=true {
                      args "install" "--path" "./"
                  }
              }
              bar
          }
      }
    '';
    home.file.".config/zellij/layouts/remote.kdl".text = /*kdl*/ '' 
      layout {
        pane command="ssh"{
          args "sargo@192.168.1.3"
        }
      }
    '';
  };
}

