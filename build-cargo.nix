{ pkgs, src, ... }:

pkgs.rustPlatform.buildRustPackage {
  name = "wgsl-analyzer";
  src = builtins.toString src;
  cargoSha256 = "sha256-gdw2AOTkjzdZIu86FNuwDfVn2Cg1REfEhIWpiuXm8gQ=";
  target = "x86_64-unknown-linux-gnu";
}
