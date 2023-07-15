{ home-manager, pkgs , ... }@args:
let palette = (import ../misc/palettes.nix).tokionight;
in {
  # Disable root login
  users.users.root.hashedPassword = "!";
  imports = [ (import "${home-manager}/nixos") ];
  home-manager.users.root= { lib, ... }: {
    imports = map (x: import (x) (args // { inherit palette lib pkgs; })) [
      ../home/starship.nix
      ../home/lf.nix
      ../home/nu.nix
      ../home/fish.nix
      ../home/helix.nix
      ../home/zellij.nix
      ../home/zoxide.nix
    ];

      # home.username = "root";
      home.homeDirectory = "/root";
      home.stateVersion = "23.05";
  };
}
