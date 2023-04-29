{ pkgs, ... }: {
  programs.starship = {
    enable = true;
    package = pkgs.unstable.starship;
    settings = let
      bg = "#282828"; # main background
      br_bg = "#3c3836";
      bg2 = "#504945";
      bg3 = "#665c54";
      bg4 = "#7c6f64";
      fg = "#fbf1c7";
      br_fg = "#ebdbb2"; # main foreground
      fg2 = "#d5c4a1";
      fg3 = "#bdae93";
      fg4 = "#a89984"; # gray0
      gray = "#a89984";
      br_gray = "#928374";
      red = "#cc241d";
      br_red = "#fb4934"; # bright
      green = "#98971a";
      br_green = "#b8bb26";
      yellow = "#d79921";
      br_yellow = "#fabd2f";
      blue = "#458588";
      br_blue = "#83a598";
      purple = "#b16286";
      br_purple = "#d3869b";
      aqua = "#689d6a";
      br_aqua = "#8ec07c";
      orange = "#d65d0e";
      br_orange = "#fe8019";

      main_format = builtins.concatStringsSep "[](fg:${br_bg} bg:${bg2})[](fg:${bg2} bg:${br_bg})" [
        "[❆](bg:${br_bg} fg:${br_blue})"
        "$directory"
        "$nix_shell"
        "$git_branch$git_metrics$git_status" 
        "$rust"
        "$time"
        "$cmd_duration"
      ];
    in {
      format = "${main_format}\n$character";

      palette = "gruvbox";
      directory.format =
        "[ $path](bg:${br_bg} fg:${br_yellow})[$read_only](bg:${br_bg})";
      git_branch = {
        style = "bg:${br_bg} fg:${br_aqua}";
        format = "[ $symbol$branch($remote_branch)]($style)";
      };
      git_status = {
        style = "bg:${br_bg} fg:${br_orange}";
        format = "[ \\[$all_status$ahead_behind\\]]($style)";
      };
      git_metrics = {
        disabled = false;
        style = "bg:${br_bg} fg:${br_orange}";
        format =
          "[ +$added ](bg:${br_bg} fg:${br_green})[-$deleted](bg:${br_bg} fg:${br_red})";
      };
      rust.format = "[ $symbol($version)](fg:${br_orange} bg:${br_bg})";
      time = {
        disabled = false;
        use_12hr = true;
        format = "[ $time](bg:${br_bg} fg:${br_green})";
        time_format = "%I:%M %p";
      };
      cmd_duration = {
        format = "[ took](bg:${br_bg})[ $duration]($style)";
        style = "bg:${br_bg} fg:${br_purple}";
      };
      nix_shell = {
        format = ''[ ❆ $state shell](fg:${br_blue} bg:${br_bg})'';
      };
      palettes = {
        gruvbox = {
          bg = "${bg}"; # main background
          br_bg = "${br_bg}";
          bg2 = "${bg2}";
          bg3 = "${bg3}";
          bg4 = "${bg4}";
          fg = "${fg}";
          br_fg = "${br_fg}"; # main foreground
          fg2 = "${fg2}";
          fg3 = "${fg3}";
          fg4 = "${fg4}"; # gray0
          gray = "${gray}";
          br_gray = "${br_gray}";
          red = "${red}";
          br_red = "${br_red}"; # bright
          green = "${green}";
          br_green = "${br_green}";
          yellow = "${yellow}";
          br_yellow = "${br_yellow}";
          blue = "${blue}";
          br_blue = "${br_blue}";
          purple = "${purple}";
          br_purple = "${br_purple}";
          aqua = "${aqua}";
          br_aqua = "${br_aqua}";
          orange = "${orange}";
          br_orange = "${br_orange}";

        };
      };
    };
  };
}
