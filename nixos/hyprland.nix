{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    hyprland-protocols
    hyprland-share-picker
    new-terminal-hyprland
    eww-bar
    blueberry
    gamescope
    prismlauncher
    (builtins.trace (builtins.toString glfw-wayland) glfw-wayland)
  ];
  xdg.portal.extraPortals =
    [ pkgs.xdg-desktop-portal-hyprland pkgs.xdg-desktop-portal-gtk ];
  programs.hyprland = { enable = true; };
}
