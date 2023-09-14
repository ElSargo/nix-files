{ firefox-theme, ... }: {
  programs.firefox.profiles.sargo = {
    userChrome = ''
      @import "firefox-gnome-theme/userChrome.css";
    '';
    userContent = ''
      @import "firefox-gnome-theme/userContent.css";
    '';
  };
  home.file.".mozilla/firefox/sargo/chrome/firefox-gnome-theme/".source =
    "${firefox-theme}";
}
