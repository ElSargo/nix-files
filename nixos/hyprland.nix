{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    new-terminal-hyprland
    eww-bar
    blueberry
  ];
  services.cpupower-gui.enable = true;
  programs.hyprland = { enable = true; };
}
