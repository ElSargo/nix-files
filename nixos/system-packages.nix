{ pkgs, ... }:
let

  audio = with pkgs; [ psst qpwgraph jamesdsp ];

  utils = with pkgs; [
    unstable.slides
    nix-prefetch-git
    keepassxc
    wl-clipboard
    wofi
    syncthing
    kitty
  ];

  coding = with pkgs; [ unstable.helix sccache ];

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
    git
  ];
compat = with pkgs; [
    vulkan-tools
    lutris
    vulkan-loader
    vulkan-headers
  vulkan-caps-viewer
  vulkan-cts
  vulkan-tools-lunarg
  vulkan-extension-layer
  vulkan-validation-layers
  vk-bootstrap
  vkdt-wayland
];
  desktop = with pkgs; [ inlyne libreoffice ];

  browsers = with pkgs; [ unstable.firefox ];

  custom = with pkgs; [ unixchadbookmarks nvim wgsl-analyzer zellij-runner ];

in pkgs.lib.flatten  [ audio utils coding terminal desktop browsers custom compat pkgs.nixVersions.nix_2_17 ]

