{ pkgs, ... }:
let

  audio = with pkgs; [ pulsemixer pavucontrol pulseaudio ];

  gnome = with pkgs; [
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
  ];

  gtk = with pkgs; [
    unstable.gtk-engine-murrine
    gruvbox-dark-gtk
    gruvbox-dark-icons-gtk
    catppuccin-gtk
  ];

  dexktop-portal = with pkgs; [
    xdg-desktop-portal
    xdg-desktop-portal-wlr
    xdg-desktop-portal-gtk
  ];

  fonts = with pkgs; [
    unstable.fontconfig
    unstable.freetype
    font-awesome
    jetbrains-mono
  ];

  desktop = with pkgs; [ waybar ];

  compat = with pkgs; [ pkg-config libxkbcommon gcc openssl ];

in {

  environment.systemPackages = with pkgs;
    [
      cmake
      unzip
      killall
      skim
      cachix
      syncthing
      thunderbird
      any-nix-shell
      unstable.wayland
      unstable.helix
      unstable.firefox
      unstable.ncspot
      unstable.librewolf
      unstable.qpwgraph
      unstable.jamesdsp
      unstable.chromium
    ] ++ gnome ++ gtk ++ dexktop-portal ++ fonts ++ desktop ++ compat ++ audio;
}
