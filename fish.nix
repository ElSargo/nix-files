{ pkgs, palette, ... }: {

  programs.fish = {
    enable = true;
    functions = {
      fhx = {
        body = # fish
          ''
            hx $(sk --ansi -i -c 'rg --line-number "{}"' | cut -d : -f1,2)
          '';
        description = "Fuzzy find conntentes of files and open in hx";
      };
      lfcd = {
        body = # fish
          ''
            set tmp (mktemp)
              # `command` is needed in case `lfcd` is aliased to `lf`
              command lf -last-dir-path=$tmp $argv
              if test -f "$tmp"
                  set dir (cat $tmp)
                  rm -f $tmp
                  if test -d "$dir"
                      if test "$dir" != (pwd)
                          cd $dir
                      end
                  end
              end
          '';
        description = "Change dirs with lf";
      };
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
      rebuild = {
        body = # fish
          "sudo cp /home/sargo/nix-files/*.nix /etc/nixos/ && sudo nixos-rebuild switch ";
        description = "Rebuild the system configuration";
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
      open_system = {
        body = # fish
          ''
            ~/projects/open_system/target/release/hyprtest
          '';
        description = "Goto the session or open it";
      };
      dmenu = {
        body = # fish
          ''
            wofi --show dmenu 
          '';
        description = "Dmenu for wayland or x using wofi or rofi";
      };
      copy_history = {
        body = # fish
          "history | fzf | xc";
        description = "Copy a previously run command";
      };
    };
    shellAliases = {
      xc = "wl-copy";
      clip = "wl-copy";
      lf = "lfcd";
    };
    shellAbbrs = {
      hxb = "~/.cargo/bin/hx --config ~/.config/helix/bleeding_config.toml";
      i = "nix-env -iA nixos.";
      q = "exit";
      ":q" = "exit";
      c = "clear";
      ls = "exa -l";
      r = "reset";
      xplr = "cd $(/usr/bin/env xplr)";
      ns = "nix-shell";
      za = "zellij a";
      zl =
        " zellij a $(pwd | sd '/' '\\n' | tail -n 1) || zellij --layout ./layout.kdl -s $(pwd | sd '/' '\\n' | tail -n 1)";
      lt = "hyprctl dispatch layoutmsg orientationtop";
      lr = "hyprctl dispatch layoutmsg orientationright";
      lb = "hyprctl dispatch layoutmsg orientationbottom";
      ll = "hyprctl dispatch layoutmsg orientationleft";
      lc = "hyprctl dispatch layoutmsg orientationcenter";

    };
    shellInit = # fish
      ''
        export EDITOR="hx"
        export VISUAL="hx"
        export BROWSER="librewolf"
      '';
    interactiveShellInit = # fish
      ''
        set fish_greeting
        bind \ce edit_command_buffer
        bind \ch copy_history  
        zoxide init fish | source
        starship init fish | source
        set -Ux STARSHIP_LOG error
        any-nix-shell fish --info-right | source
        export DIRENV_LOG_FORMAT=
        set fish_color_normal ${builtins.substring 1 6 palette.br_blue}
        set fish_color_command ${builtins.substring 1 6 palette.br_blue}
        set fish_color_option ${builtins.substring 1 6 palette.br_yellow}
        set fish_color_escape ${builtins.substring 1 6 palette.br_orange}
        set fish_color_end ${builtins.substring 1 6 palette.br_orange}
        set fish_color_cancel ${builtins.substring 1 6 palette.br_orange}
        set fish_color_redirection ${builtins.substring 1 6 palette.br_orange}
        set fish_color_status ${builtins.substring 1 6 palette.br_red}
        set fish_color_quote ${builtins.substring 1 6 palette.br_green}
        set fish_color_comment ${builtins.substring 1 6 palette.gray}
        set fish_color_keyword ${builtins.substring 1 6 palette.br_red}
        set fish_color_valid_path ${builtins.substring 1 6 palette.br_green}
        set fish_pager_color_progress ${
          builtins.substring 1 6 palette.br_yellow
        }
        set fish_pager_color_progress --background ${
          builtins.substring 1 6 palette.br_bg
        }
        set fish_pager_color_background --background ${
          builtins.substring 1 6 palette.br_bg
        }
        set fish_pager_color_prefix ${builtins.substring 1 6 palette.green}
        set fish_pager_color_completion ${
          builtins.substring 1 6 palette.br_green
        }
        set fish_pager_color_description ${builtins.substring 1 6 palette.fg}
        set fish_pager_color_selected_background --background ${
          builtins.substring 1 6 palette.br_orange
        }
        set fish_pager_color_selected_prefix ${
          builtins.substring 1 6 palette.br_bg
        }
        set fish_pager_color_selected_completion ${
          builtins.substring 1 6 palette.bg2
        }
        set fish_pager_color_selected_description ${
          builtins.substring 1 6 palette.br_bg
        }
        set fish_pager_color_secondary_background --background ${
          builtins.substring 1 6 palette.bg2
        }
        set fish_pager_color_secondary_prefix ${
          builtins.substring 1 6 palette.green
        }
        set fish_pager_color_secondary_completion ${
          builtins.substring 1 6 palette.br_green
        }
        set fish_pager_color_secondary_description ${
          builtins.substring 1 6 palette.fg
        }
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
      }
      {
        name = "colored-man-pages";
        src = pkgs.fetchFromGitHub {
          owner = "PatrickF1";
          repo = "colored_man_pages.fish";
          rev = "f885c2507128b70d6c41b043070a8f399988bc7a";
          sha256 = "ii9gdBPlC1/P1N9xJzqomrkyDqIdTg+iCg0mwNVq2EU=";
        };
      }
      {
        name = "sponge";
        src = pkgs.fetchFromGitHub {
          owner = "meaningful-ooo";
          repo = "sponge";
          rev = "384299545104d5256648cee9d8b117aaa9a6d7be";
          sha256 = "MdcZUDRtNJdiyo2l9o5ma7nAX84xEJbGFhAVhK+Zm1w=";
        };
      }
      {
        name = "x";
        src = pkgs.fetchFromGitHub {
          owner = "Molyuu";
          repo = "x";
          rev = "43dbf864f67c0b548845f30287c42e804cf1fa8c";
          sha256 = "sha256-oYVZoDCmY9zl5pLAKmO8xvMCSAe6vxf+yFpB6o8koos=";
        };
      }
    ];
  };
}
