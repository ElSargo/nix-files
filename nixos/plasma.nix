{pkgs,...}:{
  services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  environment.systemPackages = with pkgs; [ libsForQt5.qtstyleplugin-kvantum latte-dock unstable.libsForQt5.applet-window-buttons ];
}
