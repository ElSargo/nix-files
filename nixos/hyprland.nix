{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    hyprland-protocols
    hyprland-share-picker
    new-terminal-hyprland
    eww-bar
    blueberry
    gamescope
  ];
  xdg.portal.extraPortals = [
    pkgs.xdg-desktop-portal-hyprland
  ];
  programs.hyprland = { enable = true; };
}
