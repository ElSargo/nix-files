{ mozillaOverlay, src, ... }:
let
  pkgs = import <nixpkgs> { overlays = [ mozillaOverlay ]; };
  rust = (pkgs.rustChannelOf { channel = "nightly"; }).rust.override {
    targets = [ "x86_64-unknown-linux-gnu" ];
  };
  rustPlatform = pkgs.makeRustPlatform {
    cargo = rust;
    rustc = rust;
  };

in rustPlatform.buildRustPackage {
  name = "new-termainl-hyprland";
  src = builtins.toString src;
  cargoSha256 = "sha256-gdw2AOTkjzdZIu86FNuwDfVn2Cg1REfEhIWpiuXm8gQ=";
  target = "x86_64-unknown-linux-gnu";
}
