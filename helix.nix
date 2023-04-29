{ pkgs, ... }: {
  programs.helix = {
    enable = true;
    package = pkgs.unstable.helix;
    settings = {
      theme = "gruvbox";
      editor = {
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
        soft-wrap = { enable = true; };
        lsp.display-messages = true;
        lsp.display-inlay-hints = true;
        indent-guides = {
          render = true;
          character = "│";
        };
      };
      keys = {
        normal = {
          X = [
            "goto_first_nonwhitespace"
            "select_mode"
            "goto_line_end"
            "normal_mode"
          ];
          "esc" = [ "collapse_selection" "keep_primary_selection" ];
        };
      };
    };
  };
}
