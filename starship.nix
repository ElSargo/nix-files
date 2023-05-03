{ pkgs, palette, ... }:
let
  bg = palette.br_bg;
  sep = palette.bg2;
in {
  programs.starship = {
    enable = true;
    package = pkgs.unstable.starship;
    settings = let
      main_format = builtins.concatStringsSep
        "[](fg:${bg} bg:${sep})[](fg:${sep} bg:${bg})" [
          "[❆](bg:${bg} fg:${palette.br_blue})"
          "$time"
          "$directory"
          "$git_branch$git_metrics$git_status"
          "$nix_shell"
          "$rust"
          "$cmd_duration"
        ];
    in {
      format = ''
        ${main_format}[](fg:${bg})
        $jobs$character'';

      palette = "gruvbox";
      directory = {
        format =
          "[ $path](bg:${bg} fg:${palette.br_yellow})[$read_only](bg:${bg})";
        substitutions = {
          "Documents" = "";
          "Downloads" = " ";
          "Music" = " ";
          "Pictures" = " ";
          "nix-files" = "❆";
          "~/projects" = "";
        };
      };
      git_branch = {
        style = "bg:${bg} fg:${palette.br_blue}";
        format = "[ $symbol$branch($remote_branch)]($style)";
      };
      git_status = {
        style = "bg:${bg} fg:${palette.br_orange}";
        format = "[ \\[$all_status$ahead_behind\\]]($style)";
      };
      git_metrics = {
        disabled = false;
        style = "bg:${bg} fg:${palette.br_orange}";
        format =
          "[ +$added ](bg:${bg} fg:${palette.br_green})[-$deleted](bg:${bg} fg:${palette.br_red})";
      };
      rust.format = "[ $symbol($version)](fg:${palette.br_orange} bg:${bg})";
      time = {
        disabled = false;
        use_12hr = true;
        format = "[ $time](bg:${bg} fg:${palette.br_green})";
        time_format = "%I:%M %p";
      };
      cmd_duration = {
        format = "[ took](bg:${bg})[ $duration]($style)";
        style = "bg:${bg} fg:${palette.br_purple}";
      };
      nix_shell = {
        format = "[ ❆ $state shell](fg:${palette.br_blue} bg:${bg})";
      };
      palettes = {
        gruvbox = {
          bg = "${palette.bg}"; # main background
          br_bg = "${bg}";
          bg2 = "${sep}";
          bg3 = "${palette.bg3}";
          bg4 = "${palette.bg4}";
          fg = "${palette.fg}";
          br_fg = "${palette.br_fg}"; # main foreground
          fg2 = "${palette.fg2}";
          fg3 = "${palette.fg3}";
          fg4 = "${palette.fg4}"; # gray0
          gray = "${palette.gray}";
          br_gray = "${palette.br_gray}";
          red = "${palette.red}";
          br_red = "${palette.br_red}"; # bright
          green = "${palette.green}";
          br_green = "${palette.br_green}";
          yellow = "${palette.yellow}";
          br_yellow = "${palette.br_yellow}";
          blue = "${palette.blue}";
          br_blue = "${palette.br_blue}";
          purple = "${palette.purple}";
          br_purple = "${palette.br_purple}";
          aqua = "${palette.aqua}";
          br_aqua = "${palette.br_aqua}";
          orange = "${palette.orange}";
          br_orange = "${palette.br_orange}";

        };
      };
    };
  };
}
