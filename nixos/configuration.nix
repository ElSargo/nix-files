{ pkgs, ... }: {
  imports = [ ./remaps.nix ./fonts.nix ];

  systemd.watchdog.rebootTime = "10s";
  systemd.extraConfig = ''
    DefaultTimeoutStopSec=10s
  '';

  environment = {
    sessionVariables = { NIXOS_OZONE_WL = "1"; };
    systemPackages = (import ./system-packages.nix { inherit pkgs; });
  };

  nix = {
    settings = {
      warn-dirty = false;
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

  };

  users.defaultUserShell = pkgs.unstable.fish;

  # Enable networking
  networking = {
    networkmanager.enable = true;
    firewall.allowedTCPPorts = [ 22 ];
    nameservers = [ "192.168.1.1" "1.1.1.1" "8.8.8.8" ];
    extraHosts = builtins.concatStringsSep "\n" [
      "192.168.1.201 SargoLaptop"
      "192.168.1.202 SargoPi"
    ];
    stevenblack = {
      block = [ "fakenews" "gambling" "porn" ];
      enable = true;
    };
  };

  services = {
    syncthing.enable = true;
    flatpak.enable = true;
    openssh.enable = true;
    openssh.settings.PermitRootLogin = "no";
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
    printing.enable = true;
    xserver = {
      enable = true;
      desktopManager = { xterm.enable = false; };
      libinput.enable = true;
      excludePackages =
        [ pkgs.xterm pkgs.gnome.gnome-terminal pkgs.gnome-console ];
      layout = "us";
    };
  };
  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };

  xdg.portal = { enable = true; };

  sound.enable = true;

  programs = {
    command-not-found.enable = false;
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  hardware = {
    pulseaudio.enable = false;
    bluetooth.enable = true;
    opengl.enable = true;
  };

  nixpkgs = { config.allowUnfree = true; };

  time.timeZone = "Pacific/Auckland";
  i18n = {
    extraLocaleSettings = {
      LC_ADDRESS = "en_NZ.UTF-8";
      LC_IDENTIFICATION = "en_NZ.UTF-8";
      LC_MEASUREMENT = "en_NZ.UTF-8";
      LC_MONETARY = "en_NZ.UTF-8";
      LC_NAME = "en_NZ.UTF-8";
      LC_NUMERIC = "en_NZ.UTF-8";
      LC_PAPER = "en_NZ.UTF-8";
      LC_TELEPHONE = "en_NZ.UTF-8";
      LC_TIME = "en_NZ.UTF-8";
    };
  };

  system.stateVersion = "23.05";
}
