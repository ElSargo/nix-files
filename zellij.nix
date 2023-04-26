{ pkgs, ... }: {
  programs.zellij = {
    enable = true;
    package = pkgs.unstable.zellij;
    settings = {
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
          fg = "#3c3836";
          bg = "#282828";
          black = "#504945";
          red = "#98971a"; # <-│switch
          green = "#fb4934"; # <-│
          yellow = "#d79921";
          blue = "#458588";
          magenta = "#b16286";
          cyan = "#689d6a";
          white = "#fbf1c7";
          orange = "#d65d0e";
        };
      };
    };
  };
}
