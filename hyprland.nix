{ ... }: {
  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = # kdl
      ''
        # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
        bind = SUPER, Return, exec, projects/new-terminal-hyprland/target/release/new-terminal-hyprland
        bind = SUPER, L, exec, projects/new-terminal-hyprland/target/release/new-terminal-hyprland lazygit
        bind = SUPER, T, exec, projects/new-terminal-hyprland/target/release/new-terminal-hyprland cargo test
        bind = SUPER, R, exec, projects/new-terminal-hyprland/target/release/new-terminal-hyprland cargo run
        bind = SUPERSHIFT, R, exec, projects/new-terminal-hyprland/target/release/new-terminal-hyprland cargo run --release

        bind = SUPER, G, exec, projects/unixchadbookmarks/target/release/unixchadbookmarks
        bind = SUPER, C, exec, fish -c open_system
        bind = SUPER, Q, killactive, 
        bind = SUPERSHIFT, F, exec, pcmanfm
        bind = SUPERSHIFT, Space, togglefloating, 
        bind = SUPERSHIFT, Return, exec, wofi --show drun
        bind = SUPER, P, pseudo, # dwindle
        bind = SUPER, W, exec, librewolf
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
        bind = SUPER, p, exec, librewolf search.nixos.org/packages?channel=22.11&query=
        bind = ,XF86AudioLowerVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ -5% 	
        bind = ,XF86AudioRaiseVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ +5%
        bind = ,XF86AudioMute, exec, pactl set-sink-volume @DEFAULT_SINK@ 0% 	
        bind = ,XF86Calculator, exec, galculator 	
        bind = ,XF86Mail, exec, librewolf mail.google.com/mail/u/0/#inbox
        bind = ,XF86KbdBrightnessUp, exec,  
        bind = ,XF86KbdBrightnessDown , exec, 
        unbind, SUPER, M
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

        monitor=HDMI-A-1,preferred,auto,1
        monitor=HDMI-A-1,transform,1
        workspace=HDMI-A-1,1


        exec = fish -c 'pidof waybar || waybar & disown'
        exec = fish -c 'pidof swaybg || swaybg -i ~/nix-files/gruv-material-texture.png & disown'
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
            gaps_out = 7
            border_size = 2
            col.active_border = rgb(fe8019) 
            col.inactive_border = rgb(282828)
            layout = master
        }
        decoration {
            screen_shader = ~/.config/hypr/shader.glsl
            rounding = 10
            blur = yes
            blur_size = 4
            blur_passes = 1
            blur_new_optimizations = on

            drop_shadow = true
            shadow_range = 20
            shadow_render_power = 3
            col.shadow = rgba(1a1a1aee)
            shadow_offset = [-10, -10]
        }
        animations {
            enabled = yes
            animation = windows, 1, 2, default, slide
            animation = windowsOut, 1, 2, default, slide
            animation = border, 1, 10, default
            animation = fade, 1, 7, default
            animation = workspaces, 1, 2, default
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
            workspace_swipe_forever = true;
            workspace_swipe_cancel_ratio = 0.25;
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
}
