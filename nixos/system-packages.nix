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
    change-wallpaper
  ];
  desktop = with pkgs; [ inlyne libreoffice thunderbird unstable.firefox ];

  custom = with pkgs; [ unixchadbookmarks nvim wgsl-analyzer ];

in pkgs.lib.flatten [
  audio
  utils
  coding
  terminal
  desktop
  custom
  pkgs.nixVersions.nix_2_17
]

