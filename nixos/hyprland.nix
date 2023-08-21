{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    new-terminal-hyprland
    eww-bar
    blueberry
  ];
  programs.hyprland = { enable = true; };
}
