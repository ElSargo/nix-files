{ pkgs, palette, ... }: {
  home.packages = with pkgs.unstable; [ nil marksman taplo ];
  programs.helix = {
    enable = true;
    package = pkgs.unstable.helix;
    themes = {
      gruvy = {
        inherits = "gruvbox";
        "ui.background" = {
          fg = "foreground";
          bg = "background";
        };
        # "comment" = {  modifiers = ["italic"]; };
        # "function" = {  modifiers = ["italic"]; };
        # "keyword" = {  modifiers = ["italic"]; };
        # "keyword.function" = {  modifiers = ["italic"]; };
        # "variable.parameter" = {  modifiers = ["italic"]; };
        # "markup.italic" = {  modifiers = ["italic"]; };
        # "markup.quote" = {  modifiers = ["italic"]; };
      };
      tokio = {
        inherits = "tokyonight";
        "ui.background" = {
          fg = "foreground";
          bg = "background";
        };
      };
    };
    settings = {
      theme = palette.helix_theme;
      editor = {
        statusline = {
          left = [ "mode" "spinner" "file-name" "file-modification-indicator" ];
          center = [ "workspace-diagnostics" "version-control" ];
          right = [
            "diagnostics"
            "selections"
            "position"
            "total-line-numbers"
            "position-percentage"
            "file-encoding"
          ];
        };
        line-number = "relative";
        scrolloff = 10;
        cursorline = true;
        auto-save = true;
        color-modes = true;
        bufferline = "multiple";
        cursor-shape = {
          insert = "bar";
          normal = "block";
        };
        lsp.display-messages = true;
        lsp.display-inlay-hints = true;
        indent-guides = {
          render = true;
          character = "│";
        };
      };
      keys = {
        normal = let quote-file = pkgs.writeText "quote" ''"'';
        in {
          X = [
            "goto_first_nonwhitespace"
            "select_mode"
            "goto_line_end"
            "normal_mode"
          ];
          A-l = [
            "collapse_selection"
            ":open ${pkgs.writeText "left-bracket" "{"}"
            "search_selection"
            ":bc"
            "search_next"
            "select_mode"
            "match_brackets"
            "extend_char_left"
            "flip_selections"
            "extend_char_right"
            "normal_mode"
          ];
          A-h = [
            "collapse_selection"
            ":open ${pkgs.writeText "right-bracket" "}"}"
            "search_selection"
            ":bc"
            "search_prev"
            "select_mode"
            "match_brackets"
            "extend_char_right"
            "flip_selections"
            "extend_char_left"
            "normal_mode"
          ];
          A-j = [
            "collapse_selection"
            ":open ${pkgs.writeText "left-paren" "("}"
            "search_selection"
            ":bc"
            "search_next"
            "select_mode"
            "match_brackets"
            "extend_char_left"
            "flip_selections"
            "extend_char_right"
            "normal_mode"
          ];
          A-k = [
            "collapse_selection"
            ":open ${pkgs.writeText "right-paren" ")"}"
            "search_selection"
            ":bc"
            "search_prev"
            "select_mode"
            "match_brackets"
            "extend_char_right"
            "flip_selections"
            "extend_char_left"
            "normal_mode"
          ];
          C-l = [
            "collapse_selection"
            ":open ${pkgs.writeText "left-brace" "["}"
            "search_selection"
            ":bc"
            "search_next"
            "select_mode"
            "match_brackets"
            "extend_char_left"
            "flip_selections"
            "extend_char_right"
            "normal_mode"
          ];
          C-h = [
            "collapse_selection"
            ":open ${pkgs.writeText "right-brace" "]"}"
            "search_selection"
            ":bc"
            "search_prev"
            "select_mode"
            "match_brackets"
            "extend_char_right"
            "flip_selections"
            "extend_char_left"
            "normal_mode"
          ];
          C-j = [
            "collapse_selection"
            ":open ${quote-file}"
            "search_selection"
            ":bc"
            "search_next"
            "select_mode"
            "match_brackets"
            "extend_char_left"
            "flip_selections"
            "extend_char_right"
            "normal_mode"
          ];
          C-k = [
            "collapse_selection"
            ":open ${quote-file}"
            "search_selection"
            ":bc"
            "search_prev"
            "select_mode"
            "match_brackets"
            "extend_char_right"
            "flip_selections"
            "extend_char_left"
            "normal_mode"
          ];
          esc = [ "collapse_selection" "keep_primary_selection" ];
          space = { n = [ ":write-all" ":sh nixfmt *.nix" ":reload-all" ]; };
        };
      };
    };
  };
}
