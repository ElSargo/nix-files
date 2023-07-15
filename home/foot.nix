{ pkgs, palette, ... }:
with builtins;
let color = mapAttrs (k: v: substring 1 6 v) palette;
in {
  programs.foot = {
    package = pkgs.unstable.foot;
    enable = true;

    server.enable = true;
    settings = {
      main = { font = "JetBrainsMono Nerd Font:size=10"; };
      colors = {

        alpha = 0.85;
        background = color.bg;
        foreground = color.fg;

        ## Normal/regular colors (color color 0-7)
        regular0 = color.bg2;
        regular1 = color.red;
        regular2 = color.green;
        regular3 = color.yellow;
        regular4 = color.blue;
        regular5 = color.purple;
        regular6 = color.aqua;
        regular7 = color.white;

        ## Bright colors (color color 8-15)
        bright0 = color.bg3;
        bright1 = color.br_red;
        bright2 = color.br_green;
        bright3 = color.br_yellow;
        bright4 = color.br_blue;
        bright5 = color.purple;
        bright6 = color.br_aqua;
        bright7 = color.fg2;
      };
    };
  };
}
