{ pkgs, ... }: {
  programs.kitty = {
    enable = true;
    package = pkgs.unstable.kitty;
    # theme  = "Gruvbox Dark";
    settings = {
      font_family = "JetbrainsMono";
      update_check_interval = 0;
      hide_window_decorations = "yes";
      resize_in_steps = "yes";
      confirm_os_window_close = 0;
      remember_window_size = "yes";
      background_opacity = "0.85";
      allow_remote_control = "yes";
      map = "ctrl+shift+enter new_os_window_with_cwd";
      font_size = 13;

      # theme  = "Gruvbox Dark";
      selection_foreground = "#ebdbb2";
      selection_background = "#d65d0e";

      background = "#282828";
      foreground = "#ebdbb2";

      color0 = "#3c3836";
      color1 = "#cc241d";
      color2 = "#98971a";
      color3 = "#d79921";
      color4 = "#458588";
      color5 = "#b16286";
      color6 = "#689d6a";
      color7 = "#a89984";
      color8 = "#928374";
      color9 = "#fb4934";
      color10 = "#b8bb26";
      color11 = "#fabd2f";
      color12 = "#83a598";
      color13 = "#d3869b";
      color14 = "#8ec07c";
      color15 = "#fbf1c7";

      cursor = "#bdae93";
      cursor_text_color = "#665c54";

      url_color = "#458588";

    };
  };
}
