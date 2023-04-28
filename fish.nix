{ pkgs, ... }: {

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
      zl =
        " zellij a $(pwd | sd '/' '\\n' | tail -n 1) || zellij --layout ./layout.kdl -s $(pwd | sd '/' '\\n' | tail -n 1)";
    };
    shellInit = # fish
      ''
        export EDITOR="hx"
        export VISUAL="hx"
        export BROWSER="firefox"
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
