{ pkgs, ... }: {
  programs.helix = {
    enable = true;
    package = pkgs.unstable.helix;
    settings = {
      theme = "gruvbox";
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
        normal = {
          X = [
            "goto_first_nonwhitespace"
            "select_mode"
            "goto_line_end"
            "normal_mode"
          ];
          "esc" = [ "collapse_selection" "keep_primary_selection" ];
          space = { n = [ ":write-all" ":sh nixfmt *.nix" ":reload-all" ]; };
        };
      };
    };
  };
}
