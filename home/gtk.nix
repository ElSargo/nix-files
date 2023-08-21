{ pkgs, ... }: {
  gtk.enable = true;
  # gtk.cursorTheme.package = pkgs.gnome.adwaita-icon-theme;
  gtk.theme.name = "Adwaita-dark";
  gtk.theme.package = pkgs.gnome.gnome-themes-extra;
}
