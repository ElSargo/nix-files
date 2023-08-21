{pkgs, ... }: {
  services.xserver.desktopManager.gnome.enable = true;

  environment = {
    gnome.excludePackages =  with pkgs.gnome; with pkgs.gnomeExtensions; [
      cheese # webcam tool
      gnome-music
      gnome-terminal
      gedit # text editor
      epiphany # web browser
      tali # poker game
      iagno # go game
      hitori # sudoku game
      atomix # puzzle game
    ] ++ [ pkgs.gnome-tour ] ++ [
    removable-drive-menu
    caffeine
    dash-to-dock
    blur-my-shell
    uptime-indicator
    grand-theft-focus
  ];
    
  };
}
