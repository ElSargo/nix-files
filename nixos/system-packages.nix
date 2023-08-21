{ pkgs, ... }:
let

  audio = with pkgs; [ unstable.psst unstable.qpwgraph unstable.jamesdsp ];

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
  ];

  desktop = with pkgs; [ inlyne libreoffice ];

  browsers = with pkgs; [ unstable.firefox ];

  custom = with pkgs; [ unixchadbookmarks nvim wgsl-analyzer zellij-runner ];

in [ audio utils coding terminal desktop browsers custom ]

