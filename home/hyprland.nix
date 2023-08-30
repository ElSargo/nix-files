{ pkgs, browser ? "firefox", palette, ... }:
with builtins;
let
  pk = name: "${pkgs.${name}}/bin/${name}";
  colors = builtins.mapAttrs (k: v: builtins.substring 1 6 v) palette;
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

    SUPERALT = { Return = "exec, [size 30% 30% ;silent;float] foot"; };
    SUPERCTRL = {
      W = "resizeactive, 0 -60";
      A = "resizeactive, -60 0";
      S = "resizeactive, 0 60";
      D = "resizeactive, 60 0";
      P = "pseudo, # dwindle";
    };

    SUPER = {
      TAB = "changegroupactive";
      mouse_up = "workspace, e-1";
      mouse_down = "workspace, e+1";
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
      p = "exec, ${browser} search.nixos.org/packages?channel=23.05&query=";
      Space = "layoutmsg, swapwithmaster";
      V = "layoutmsg, focusmaster";
      K = "layoutmsg, cycleprev";
      J = "layoutmsg, cyclenext";
      H = "workspace, e-1";
      L = "workspace, e+1";
      W = "movefocus, u";
      A = "movefocus, l";
      S = "movefocus, d";
      D = "movefocus, r";
      F = "fullscreen,0";
      B = "exec, ${browser}";
      grave = "togglespecialworkspace,";
      Q = "killactive, ";
      G = "exec, unixchadbookmarks ~/nix-files/bookmarks";
      Return = "exec, [size 40% 40%] new-terminal-hyprland foot";
      N = "workspace, empty";
    };

    SUPERSHIFT = {
      TAB = "togglegroup";
      T = "movetoworkspace,special";
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
      J = "layoutmsg, swapnext";
      K = "layoutmsg, swapprev";
      L = "exec, ${pk "fish"} -c toggle_layout";
      Z = "exec, foot fish '-c zn'";
      Q = "exit";
      Return = "exec, wofi --show drun";
      Space = "togglefloating, ";
      F = "fakefullscreen";
      B = "exec, blueberry";
      W = "movewindow, u";
      A = "movewindow, l";
      S = "movewindow, d";
      D = "movewindow, r";
    };

    "" = {

      XF86AudioRaiseVolume = "exec, wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%+";
      XF86AudioLowerVolume = "exec, wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%-";
      XF86AudioMute = "exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
      # XF86AudioRaiseVolume = "exec, pactl set-sink-volume @DEFAULT_SINK@ +5%";
      # XF86AudioLowerVolume = "exec, pactl set-sink-volume @DEFAULT_SINK@ -5%";
      # XF86AudioMute = "exec, pactl set-sink-volume @DEFAULT_SINK@ 0% 	";
      XF86Calculator = "exec, galculator";
      XF86Mail = "exec, thunderbird";
      XF86MonBrightnessUp = "exec, sudo light -A 1";
      XF86MonBrightnessDown = "exec, sudo light -U 1";
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

in {
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

          pixColor.rgb = smoothstep(0.,1.,pixColor.rgb) * vec3(1, 0.5, .2) * 0.3;    

          gl_FragColor = pixColor;
      }
    '';

  wayland.windowManager.hyprland = {
    package = pkgs.unstable.hyprland;
    enable = true;
    extraConfig = # kdl
      ''
        # exec-once=nm-applet
        exec-once=eww open-many bar bar2
        exec-once=swaybg -i ~/Pictures/flake.png
          ${unbinds}
          ${keybinds}
          ${mouse-keybinds}
          monitor=HDMI-A-1,preferred,auto,1
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
              gaps_in = 3
              gaps_out = 5
              border_size = 2
              
              col.active_border = rgb(${colors.br_orange}) 
              col.inactive_border = rgb(${colors.bg})

              col.group_border = rgba(00000000)
              col.group_border_active = rgb(${colors.br_green})
              cursor_inactive_timeout = 5
              layout = master
          }
          decoration {
              # screen_shader = ~/.config/hypr/shader.glsl
              rounding = 10
              blur {
                size = 4
                passes = 1
                noise = 0.02
                brightness = 1.15
              }

              drop_shadow = true
              shadow_range = 20
              shadow_render_power = 3
              col.shadow = rgba(1a1a1aee)
              shadow_offset = [-10, -10]
          }
          animations {
              enabled = yes
              animation = windows, 1, 3, default, slide
              animation = windowsOut, 1, 3, default, slide
              animation = border, 1, 10, default
              animation = fade, 1, 3, default
              animation = workspaces, 1, 3, default
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
          windowrule = float, \A\Z|\A\Z*|\A\Z+
          windowrule = float, ^(galculator)$
          windowrule = noborder, ^(glava)$

          misc {
            enable_swallow = true
            swallow_regex = ^(kitty)|(Alacritty)|(foot)$
            animate_manual_resizes = true
            disable_hyprland_logo = true
            disable_splash_rendering = true
          }
      '';
  };
  home.packages = with pkgs; [
    swaybg
    lazygit
    light
    galculator
    thunderbird
    wofi
    wlogout
    wireplumber
  ];

  programs.fish = {
    shellAliases = {
      lt = "hyprctl dispatch layoutmsg orientationtop";
      lr = "hyprctl dispatch layoutmsg orientationright";
      lb = "hyprctl dispatch layoutmsg orientationbottom";
      ll = "hyprctl dispatch layoutmsg orientationleft";
      lc = "hyprctl dispatch layoutmsg orientationcenter";
    };
    functions = {
      toggle_layout = {
        description = "Toggle between the hyprland master and dwindle layouts";
        body = # fish
          ''
            switch "$(hyprctl getoption general:layout)"
            case "*master*"
              hyprctl keyword general:layout dwindle
            case "*"
              hyprctl keyword general:layout master
            end
          '';
      };

      toggle_eye_saver = {
        body = # fish
          ''
            switch "$(hyprctl getoption decoration:screen_shader)"
              case "*shader.glsl*" 
                  hyprctl keyword decoration:screen_shader ~/.config/hypr/shader_eye_saver.glsl
              case '*'
                  hyprctl keyword decoration:screen_shader ~/.config/hypr/shader.glsl
              end
          '';
        description = "Toggle the eye saver shader";
      };

    };
  };

  programs.nushell = {
    shellAliases = {
      lt = "hyprctl dispatch layoutmsg orientationtop";
      lr = "hyprctl dispatch layoutmsg orientationright";
      lb = "hyprctl dispatch layoutmsg orientationbottom";
      ll = "hyprctl dispatch layoutmsg orientationleft";
      lc = "hyprctl dispatch layoutmsg orientationcenter";

    };
  };

}

