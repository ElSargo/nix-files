{ pkgs, ... }: {
  programs.bash = {
    enable = true;
    shellAliases = (import ../misc/shell_aliases.nix { inherit pkgs; });
  };
}
