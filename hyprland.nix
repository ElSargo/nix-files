{ pkgs, browser, ... }:
with builtins;
let
  helper = f: node:
    if isAttrs node then
      concatLists (attrValues
        (mapAttrs (element: child: map (c: [ element ] ++ c) (f f child)) node))
    else
      [ [ node ] ];
  smoosh = helper helper;

  keybinds = pkgs.lib.strings.concatMapStrings (s: ''
    bind = ${s} 
  '') (map (concatStringsSep ", ") (smoosh {

    SUPERALT = { Return = "exec, [size 30% 30% ;silent;float] kitty"; };

    SUPER = {
      mouse_up = "workspace, e-1";
      mouse_down = "workspace, e+1";
      S = "togglespecialworkspace,";
      "0" = "workspace, 10";
      "9" = "workspace, 9";
      "8" = "workspace, 8";
      "7" = "workspace, 7";
      "6" = "workspace, 6";
      "5" = "workspace, 5";
      "4" = "workspace, 4";
      "3" = "workspace, 3";
      "2" = "workspace, 2";
      "1" = "workspace, 1";

      p = "exec, ${browser} search.nixos.org/packages?channel=22.11&query=";
      L = "exec, fish -c toggle_layout";
      O = "layoutmsg, addmaster";
      Space = "layoutmsg, swapwithmaster";
      V = "layoutmsg, focusmaster";
      K = "layoutmsg, cycleprev ";
      J = "layoutmsg, cyclenext";
      B = "exec, blueberry";
      F = "fullscreen,0";
      W = "exec, ${browser}";
      P = "pseudo, # dwindle";
      Q = "killactive, ";
      C = "exec, fish -c open_system";
      G = "exec, projects/unixchadbookmarks/target/release/unixchadbookmarks";
      A = "exec, kitty zellij a";
      Return = "exec, [size 40% 40%] kitty";
      N = "workspace, empty";
      # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
      # Return = "exec, projects/new-terminal-hyprland/target/release/new-terminal-hyprland";
      # bind = SUPER, L, exec, projects/new-terminal-hyprland/target/release/new-terminal-hyprland lazygit
      # bind = SUPER, T, exec, projects/new-terminal-hyprland/target/release/new-terminal-hyprland cargo test
      # bind = SUPER, R, exec, projects/new-terminal-hyprland/target/release/new-terminal-hyprland cargo run
      # bind = SUPERSHIFT, R, exec, projects/new-terminal-hyprland/target/release/new-terminal-hyprland cargo run --release

    };

    SUPERSHIFT = {

      S = "movetoworkspace,special";
      "0" = "movetoworkspace, 10";
      "9" = "movetoworkspace, 9";
      "8" = "movetoworkspace, 8";
      "7" = "movetoworkspace, 7";
      "6" = "movetoworkspace, 6";
      "5" = "movetoworkspace, 5";
      "4" = "movetoworkspace, 4";
      "3" = "movetoworkspace, 3";
      "2" = "movetoworkspace, 2";
      "1" = "movetoworkspace, 1";
      L = "exec, wlogout";
      O = "layoutmsg, removemaster";
      K = "layoutmsg, swapprev ";
      J = "layoutmsg, swapnext";
      Z = "exec, kitty fish '-c zn'";
      W = "exec, nm-connection-editor";
      Q = "exec, wlogout";
      Return = "exec, wofi --show drun";
      Space = "togglefloating, ";
      F = "exec, pcmanfm";

    };

    "" = {
      XF86AudioRaiseVolume = "exec, pactl set-sink-volume @DEFAULT_SINK@ +5%";
      XF86AudioLowerVolume = "exec, pactl set-sink-volume @DEFAULT_SINK@ -5%";
      XF86AudioMute = "exec, pactl set-sink-volume @DEFAULT_SINK@ 0% 	";
      XF86Calculator = "exec, galculator 	";
      XF86Mail = "exec, thunderbird";
      XF86MonBrightnessUp = "exec, sudo light -A 5";
      XF86MonBrightnessDown = "exec, sudo light -U 5";

    };

  }));

  mouse-keybinds = pkgs.lib.strings.concatMapStrings (s: ''
    bindm = ${s} 
  '') (map (concatStringsSep ", ") (smoosh {
    SUPER = {
      "mouse:272" = "movewindow";
      "mouse:273" = "resizewindow";
    };
  }));

  unbinds = concatStringsSep "\n"
    (attrValues (mapAttrs (k: v: "unbind, ${k}, ${v}") { SUPER = "M"; }));

  execs = concatStringsSep "\n" (map (s: "exec = ${s}") [
    "fish -c 'pidof waybar || waybar & disown'"
    "fish -c 'pidof swaybg || swaybg -i ~/nix-files/gruv-material-texture.png & disown'"
  ]);

in {
  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = # zig
      ''
        ${execs}      
        ${unbinds}
        ${keybinds}
        ${mouse-keybinds}
        monitor=HDMI-A-1,preferred,auto,1
        monitor=HDMI-A-1,transform,1
        workspace=HDMI-A-1,1

        input {
            kb_layout = us
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
        windowrulev2 = float,title:^(Graze.)$
        windowrule = float, ^(nm-connection-editor)$
        windowrule = float, ^(pavucontrol)$
        windowrule = float, ^(galculator)$
        windowrule = noborder, ^(glava)$

        misc {
          enable_swallow = true
          swallow_regex = ^(kitty)|(Alacritty)$
        }
      '';
  };
}
