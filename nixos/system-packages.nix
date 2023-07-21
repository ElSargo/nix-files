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
    gnomeExtensions.removable-drive-menu
    gnomeExtensions.custom-accent-colors
    gnomeExtensions.caffeine
    gnomeExtensions.dash-to-dock
    gnomeExtensions.blur-my-shell
    gnomeExtensions.uptime-indicator
    gnomeExtensions.user-themes
    gnomeExtensions.gsconnect
    gnomeExtensions.grand-theft-focus
    # gnome.gnome-tweaks
    # gnome.gnome-themes-extra

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

  coding = with pkgs; [
    unstable.helix
    sccache
    neovide
    cmake
    unstable.lapce
    rnix-lsp
  ];

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

  desktop = with pkgs; [ unstable.thunderbird glava inlyne swaybg feh libreoffice ];

  system = with pkgs; [ cpupower-gui ];

  compat = with pkgs; [ pkg-config libxkbcommon gcc openssl unstable.wayland ];

  browsers = with pkgs; [ unstable.firefox ];

  custom = with pkgs; [
    unixchadbookmarks
    new-terminal-hyprland
    nvim
    wgsl-analyzer
    zellij-runner
    eww-bar
  ];

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
  custom
]

