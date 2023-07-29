{ pkgs, ... }:
let

  audio = with pkgs; [
    pulsemixer
    pavucontrol
    pulseaudio
    unstable.psst
    unstable.qpwgraph
    unstable.jamesdsp
  ];

  gnome = with pkgs; [
    gnomeExtensions.removable-drive-menu
    gnomeExtensions.caffeine
    gnomeExtensions.dash-to-dock
    gnomeExtensions.blur-my-shell
    gnomeExtensions.uptime-indicator
    gnomeExtensions.grand-theft-focus
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


  desktop = with pkgs; [ inlyne swaybg feh libreoffice ];

  system = with pkgs; [ cpupower-gui ];

  compat = with pkgs; [ pkg-config libxkbcommon gcc openssl unstable.wayland git ];

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
  desktop
  compat
  browsers
  system
  custom
]

