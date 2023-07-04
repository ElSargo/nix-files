{ pkgs, palette, supabar, system, ... }: {
  programs.zellij = {
    enable = true;

    package = pkgs.unstable.zellij;
    enableZshIntegration = false;
    settings = {
      # default_layout = "compact";
      ui = { pane_frames = { rounded_corners = true; }; };
      keybinds = {
        unbind = "Ctrl o";
        normal = {
          "bind \"Ctrl d\"" = { "" = "Detach"; };
          "bind \"Alt 1\"" = { GoToTab = 1; };
          "bind \"Alt 2\"" = { GoToTab = 2; };
          "bind \"Alt 3\"" = { GoToTab = 3; };
          "bind \"Alt 4\"" = { GoToTab = 4; };
          "bind \"Alt 5\"" = { GoToTab = 5; };
          "bind \"Alt 6\"" = { GoToTab = 6; };
          "bind \"Alt 7\"" = { GoToTab = 7; };
          "bind \"Alt 8\"" = { GoToTab = 8; };
          "bind \"Alt 9\"" = { GoToTab = 9; };
          "bind \"Alt 0\"" = { GoToTab = 10; };
        };
      };
      theme = "gruvbox_dark";
      themes = {
        gruvbox_dark = {
          fg = palette.br_bg;
          bg = palette.bg;
          black = palette.bg2;
          red = palette.br_green;
          green = palette.br_red;
          yellow = palette.br_yellow;
          blue = palette.br_blue;
          magenta = palette.br_purple;
          cyan = palette.br_aqua;
          orange = palette.br_orange;
          white = palette.white;
        };
      };
    };
  };
  home.file.".config/zellij/layouts/default.kdl".text = # kdl
    ''
      layout {
          default_tab_template {
              // the default zellij tab-bar and status bar plugins
              children
              pane size=1 borderless=true {
                  plugin location="file:${
                    supabar.packages.${system}.default
                  }/bin/zellij-supabar.wasm"
              }
          }
      }

    '';
}
