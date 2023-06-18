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
    unstable.gnomeExtensions.caffeine
    unstable.gnomeExtensions.dash-to-dock
    unstable.gnomeExtensions.blur-my-shell
    unstable.gnomeExtensions.uptime-indicator
    unstable.gnomeExtensions.user-themes
    unstable.gnomeExtensions.gsconnect
    unstable.gnome.gnome-tweaks
    unstable.gnome.gnome-themes-extra
  ];

  networking = with pkgs; [ blueberry blueman ];

  utils = with pkgs; [
    unstable.slides
    nix-prefetch-git
    speedcrunch
    wlogout
    keepassxc
    wl-clipboard
    wofi
    syncthing
    kitty
  ];

  coding = with pkgs; [ unstable.helix sccache cmake unstable.lapce ];

  terminal = with pkgs; [
    any-nix-shell
    unzip
    killall
    exa
    wget
    ripgrep
    trash-cli
    delta
    htop
    nixfmt
    typos
    gitui
    pastel
    cargo
  ];

  graphics = with pkgs; [ blender ];

  gtk = with pkgs; [
    unstable.gtk-engine-murrine
    gruvbox-dark-gtk
    gruvbox-dark-icons-gtk
    catppuccin-gtk
  ];

  fonts = with pkgs; [ fontconfig freetype ];

  desktop = with pkgs; [
    hyprpicker
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
  fonts
  desktop
  compat
  browsers
  system
  graphics

]

