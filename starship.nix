{ pkgs, ... }: {
  programs.starship = {
    enable = true;
    package = pkgs.unstable.starship;
    settings = {
      format = "$time in $all";
      palette = "gruvbox";
      directory = { style = "bright_yellow"; };
      git_branch = {
        style = "bright_aqua";
        format = "[$symbol$branch(:$remote_branch)]($style) ";
      };
      git_status = { style = "bright_orange"; };
      git_metrics = { disabled = false; };
      time = {
        disabled = false;
        use_12hr = true;
        format = "[$time]($style)";
        style = "bright_blue";
        time_format = "%I:%M %p";
      };
      cmd_duration = { style = "bright_purple"; };
      palettes = {
        gruvbox = {
          bg = "#282828"; # main background
          bright_bg = "#3c3836";
          bg2 = "#504945";
          bg3 = "#665c54";
          bg4 = "#7c6f64";

          fg = "#fbf1c7";
          bright_fg = "#ebdbb2"; # main foreground
          fg2 = "#d5c4a1";
          fg3 = "#bdae93";
          fg4 = "#a89984"; # gray0

          gray = "#a89984";
          bright_gray = "#928374";

          red = "#cc241d"; # neutral
          bright_red = "#fb4934"; # bright
          green = "#98971a";
          bright_green = "#b8bb26";
          yellow = "#d79921";
          bright_yellow = "#fabd2f";
          blue = "#458588";
          bright_blue = "#83a598";
          purple = "#b16286";
          bright_purple = "#d3869b";
          aqua = "#689d6a";
          bright_aqua = "#8ec07c";
          orange = "#d65d0e";
          bright_orange = "#fe8019";
        };
      };
    };
  };
}
