{ firefox-theme, ... }: {
  home.file.".mozilla/firefox/sargo/chrome/".source = "${firefox-theme}/";
}

