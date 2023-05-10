{ pkgs, ... }:
let

  audio = with pkgs; [
    pulsemixer
    pavucontrol
    pulseaudio
    unstable.ncspot
    unstable.qpwgraph
    unstable.jamesdsp
  ];

  gnome = with pkgs; [
    unstable.gnomeExtensions.custom-accent-colors
    unstable.gnomeExtensions.fuzzy-app-search
    unstable.gnomeExtensions.caffeine
    unstable.gnomeExtensions.dash-to-dock
    unstable.gnomeExtensions.blur-my-shell
    unstable.gnomeExtensions.uptime-indicator
    unstable.gnomeExtensions.user-themes
    gnomeExtensions.gsconnect
    unstable.gnome.gnome-tweaks
    unstable.gnome.nautilus
    unstable.gnome.gnome-themes-extra
    gnomeExtensions.drop-down-terminal
  ];

  networking = with pkgs; [
    blueberry
    blueman
    networkmanagerapplet

  ];

  utils = with pkgs; [
    nix-prefetch-git
    light
    cachix
    speedcrunch
    galculator
    wlogout
    keepassxc
    wl-clipboard
    wofi
    syncthing
    kitty
  ];

  coding = with pkgs; [ unstable.nil unstable.marksman sccache cmake ];

  cli = with pkgs; [
    unstable.helix
    any-nix-shell
    unzip
    killall
    skim
    sd
    exa
    wget
    ripgrep
    fzf
    xplr
    trash-cli
    delta
    htop
    chafa
    nixfmt
    typos
    gitui
    pastel
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

  desktop = with pkgs; [
    waybar
    thunderbird
    glava
    inlyne
    swaybg
    feh
    libreoffice
  ];

  compat = with pkgs; [ pkg-config libxkbcommon gcc openssl unstable.wayland ];

  browsers = with pkgs; [
    unstable.firefox
    unstable.librewolf
    unstable.vivaldi
  ];

in [
  audio
  gnome
  networking
  utils
  coding
  cli
  gtk
  dexktop-portal
  fonts
  desktop
  compat
  browsers
]

