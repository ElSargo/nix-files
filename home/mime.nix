{ pkgs, browser, ... }: {
  home.packages = with pkgs; [ libreoffice ];
  xdg = {
    enable = true;
    mimeApps = {
      enable = true;
      defaultApplications = {
        "text/plain" = "Helix.desktop";
        "application/zip" = "thunar.desktop";
        "application/rar" = "thunar.desktop";
        "application/7z" = "thunar.desktop";
        "application/*tar" = "thunar.desktop";
        "inode/directory" = "thunar.desktop";
        "application/pdf" = "draw.desktop";
        "image/*" = "${builtins.trace browser browser}.desktop";
        "video/*" = "${browser}.desktop";
        "audio/*" = "${browser}.desktop";
        "text/html" = "${browser}.desktop";
        "x-scheme-handler/http" = "${browser}.desktop";
        "x-scheme-handler/https" = "${browser}.desktop";
        "x-scheme-handler/ftp" = "${browser}.desktop";
        "x-scheme-handler/chrome" = "${browser}.desktop";
        "x-scheme-handler/about" = "${browser}.desktop";
        "x-scheme-handler/unknown" = "${browser}.desktop";
        "application/x-extension-htm" = "${browser}.desktop";
        "application/x-extension-html" = "${browser}.desktop";
        "application/x-extension-shtml" = "${browser}.desktop";
        "application/xhtml+xml" = "${browser}.desktop";
        "application/x-extension-xhtml" = "${browser}.desktop";
        "application/x-extension-xht" = "${browser}.desktop";
      };
    };
  };
}
