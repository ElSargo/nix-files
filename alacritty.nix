{ pkgs, palette, ... }: {

  programs.alacritty = {
    package = pkgs.unstable.alacritty;
    enable = true;
    settings = {
      font.normal.family = "JetbrainsMono Nerd Font";
      colors = {
        primary = {
          background = palette.bg; # base
          foreground = palette.fg; # text
          # Bright and dim foreground colors
          dim_foreground = palette.fg; # text
          bright_foreground = palette.fg; # text
        };
        # Cursor colors
        cursor = {
          text = palette.br_bg; # base
          cursor = palette.br_orange; # rosewater
        };
        vi_mode_cursor = {
          text = "#24273A"; # base
          cursor = "#B7BDF8"; # lavender
        };
        # Search colors
        search = {
          matches = {
            foreground = palette.br_bg; # base
            background = palette.br_blue; # subtext0
          };
          focused_match = {
            foreground = palette.br_bg; # base
            background = palette.br_green; # green
          };
          footer_bar = {
            foreground = palette.fg; # base
            background = palette.br_bg; # subtext0
          };
        };
        # Keyboard regex hints
        hints = {
          start = {
            foreground = "#24273A"; # base
            background = "#EED49F"; # yellow
          };
          end = {
            foreground = "#24273A"; # base
            background = "#A5ADCB"; # subtext0
          };
        };
        # Selection colors
        selection = {
          text = palette.br_yellow; # base
          background = palette.br_bg; # rosewater
        };
        # Normal colors
        normal = {
          black = palette.bg; # surface1
          red = palette.red; # red
          green = palette.green; # green
          yellow = palette.yellow; # yellow
          blue = palette.blue; # blue
          magenta = palette.purple; # pink
          cyan = palette.aqua; # teal
          white = palette.gray; # subtext1
        };
        # Bright colors
        bright = {
          black = palette.br_bg; # surface1
          red = palette.br_red; # red
          green = palette.br_green; # green
          yellow = palette.br_yellow; # yellow
          blue = palette.br_blue; # blue
          magenta = palette.br_purple; # pink
          cyan = palette.br_aqua; # teal
          white = palette.white; # subtext1
        };
      };
    };
  };
}
# colors = {
#   primary = {
#     background = "#24273A"; # base
#     foreground = "#CAD3F5"; # text
#     # Bright and dim foreground colors
#     dim_foreground = "#CAD3F5"; # text
#     bright_foreground = "#CAD3F5"; # text
#   };
#   # Cursor colors
#   cursor = {
#     text = "#24273A"; # base
#     cursor = "#F4DBD6"; # rosewater
#   };
#   vi_mode_cursor = {
#     text = "#24273A"; # base
#     cursor = "#B7BDF8"; # lavender
#   };
#   # Search colors
#   search = {
#     matches = {
#       foreground = "#24273A"; # base
#       background = "#A5ADCB"; # subtext0
#     };
#     focused_match = {
#       foreground = "#24273A"; # base
#       background = "#A6DA95"; # green
#     };
#     footer_bar = {
#       foreground = "#24273A"; # base
#       background = "#A5ADCB"; # subtext0
#     };
#   };
#   # Keyboard regex hints
#   hints = {
#     start = {
#       foreground = "#24273A"; # base
#       background = "#EED49F"; # yellow
#     };
#     end = {
#       foreground = "#24273A"; # base
#       background = "#A5ADCB"; # subtext0
#     };
#   };
#   # Selection colors
#   selection = {
#     text = "#24273A"; # base
#     background = "#F4DBD6"; # rosewater
#   };
#   # Normal colors
#   normal = {
#     black = "#494D64"; # surface1
#     red = "#ED8796"; # red
#     green = "#A6DA95"; # green
#     yellow = "#EED49F"; # yellow
#     blue = "#8AADF4"; # blue
#     magenta = "#F5BDE6"; # pink
#     cyan = "#8BD5CA"; # teal
#     white = "#B8C0E0"; # subtext1
#   };
#   # Bright colors
#   bright = {
#     black = "#5B6078"; # surface2
#     red = "#ED8796"; # red
#     green = "#A6DA95"; # green
#     yellow = "#EED49F"; # yellow
#     blue = "#8AADF4"; # blue
#     magenta = "#F5BDE6"; # pink
#     cyan = "#8BD5CA"; # teal
#     white = "#A5ADCB"; # subtext0
#   };
#   # Dim colors
#   dim = {
#     black = "#494D64"; # surface1
#     red = "#ED8796"; # red
#     green = "#A6DA95"; # green
#     yellow = "#EED49F"; # yellow
#     blue = "#8AADF4"; # blue
#     magenta = "#F5BDE6"; # pink
#     cyan = "#8BD5CA"; # teal
#     white = "#B8C0E0"; # subtext1
#   };
# };
