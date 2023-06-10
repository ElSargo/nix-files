{ pkgs, ... }:
let

  audio = with pkgs; [
    pulsemixer
    pavucontrol
    pulseaudio
    unstable.ncspot
    unstable.psst
    unstable.qpwgraph
    unstable.jamesdsp
  ];

  gnome = with pkgs; [
    unstable.gnomeExtensions.removable-drive-menu
    unstable.gnomeExtensions.custom-accent-colors
    # unstable.gnomeExtensions.fuzzy-app-search
    unstable.gnomeExtensions.caffeine
    unstable.gnomeExtensions.dash-to-dock
    unstable.gnomeExtensions.blur-my-shell
    unstable.gnomeExtensions.uptime-indicator
    unstable.gnomeExtensions.user-themes
    unstable.gnomeExtensions.gsconnect
    unstable.gnome.gnome-tweaks
    unstable.gnome.gnome-themes-extra
  ];

  networking = with pkgs; [
    blueberry
    blueman
    networkmanagerapplet

  ];

  utils = with pkgs; [
    unstable.slides
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

  coding = with pkgs; [
    unstable.nil
    unstable.marksman
    sccache
    cmake
    unstable.helix
    unstable.lapce
    taplo
  ];

  terminal = with pkgs; [
    wezterm
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
    cargo
  ];

  gtk = with pkgs; [
    unstable.gtk-engine-murrine
    gruvbox-dark-gtk
    gruvbox-dark-icons-gtk
    catppuccin-gtk
  ];

  desktop-portal = with pkgs; [
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
    hyprpicker
    waybar
    thunderbird
    glava
    inlyne
    swaybg
    feh
    libreoffice
  ];

  system = with pkgs; [ cpupower-gui ];

  compat = with pkgs; [ pkg-config libxkbcommon gcc openssl unstable.wayland ];

  browsers = with pkgs; [ unstable.librewolf unstable.vivaldi ];

in [
  audio
  gnome
  networking
  utils
  coding
  terminal
  gtk
  desktop-portal
  fonts
  desktop
  compat
  browsers
  system
]

