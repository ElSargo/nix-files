{ config, pkgs, lib, ... }: {

  environment.systemPackages = with pkgs; [
    thunderbird
    catppuccin-gtk
    gcc
    any-nix-shell
    gnome.dconf-editor
    waybar
    pulsemixer
    pavucontrol
    pulseaudio
    nodePackages_latest.typescript-language-server
    nodejs
    font-awesome 
    jetbrains-mono
    unstable.gnomeExtensions.custom-accent-colors
    unstable.gnomeExtensions.fuzzy-app-search
    unstable.gnomeExtensions.caffeine
    unstable.gnomeExtensions.dash-to-dock
    unstable.gnomeExtensions.blur-my-shell
    unstable.gnomeExtensions.uptime-indicator
    unstable.gnomeExtensions.user-themes
    unstable.gnome.gnome-tweaks
    unstable.gnome.nautilus
    unstable.gnome.gnome-themes-extra
    unstable.gtk-engine-murrine
    xdg-desktop-portal
    xdg-desktop-portal-wlr
    hyprland
    xdg-desktop-portal-gtk
    unstable.helix
    unstable.firefox
    gcc
    pkg-config
    unstable.fontconfig
    unstable.freetype
    openssl
  ];
}
