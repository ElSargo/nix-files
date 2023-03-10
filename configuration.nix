{ config, pkgs, lib, ... }:
let
  mozillaOverlay = import (fetchTarball "https://github.com/mozilla/nixpkgs-mozilla/archive/master.tar.gz");

  home-manager = fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";

  unstableTarball = fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";

  flake-compat = fetchTarball "https://github.com/edolstra/flake-compat/archive/master.tar.gz";

  hyprland = (import flake-compat {
    src = fetchTarball "https://github.com/hyprwm/Hyprland/archive/master.tar.gz";
  }).defaultNix;

  # stylix = pkgs.fetchFromGitHub {
  #   owner = "danth";
  #   repo = "stylix";
  #   rev = "...";
  #   sha256 = "...";
  # };

  in
  {
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  programs.hyprland = {
    enable = true;
    package = hyprland.packages.${pkgs.system}.default;
  };
#//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
# User setup
#//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  users.defaultUserShell = pkgs.fish;
  
  # Enable networking
  # networking.wireless.enable = true;
  networking.networkmanager.enable = true;
  networking.firewall.allowedTCPPorts = [ 22 ];
  networking.hostName = "SargoLaptop"; # Define your hostname.

  services.xserver = {
    enable = true;
    desktopManager = {
      xterm.enable = false;
      gnome.enable = true;
    };
 
    displayManager.gdm.enable = true;
    displayManager = {
        defaultSession = "hyprland";
    };
    libinput.enable = true;
    excludePackages= [ pkgs.xterm pkgs.gnome.gnome-terminal];
    layout = "us";
    # xkbVariant = "colemak";
  };
  qt5.enable = true;
  qt5.platformTheme = "gtk2";
  qt5.style = "gtk2";
  xdg.portal.wlr.enable = true;
  # Enable CUPS to print documents.
  services.printing.enable = true;
  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # jack.enable = true;
  };
  security.sudo.extraRules= [
    {
      users = [ "sargo" ];
      commands = [
         { command = "ALL" ;
           options= [ "NOPASSWD" ]; # "SETENV" # Adding the following could be a good idea
        }
      ];
    }
  ];

  
  
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.initrd.secrets = { "/crypto_keyfile.bin" = null; };
  boot.initrd.luks.devices."luks-4955bc2c-1e9b-4a8b-ab6d-125ca5b3e064".device = "/dev/disk/by-uuid/4955bc2c-1e9b-4a8b-ab6d-125ca5b3e064";
  boot.initrd.luks.devices."luks-4955bc2c-1e9b-4a8b-ab6d-125ca5b3e064".keyFile = "/crypto_keyfile.bin";
  boot.kernelPackages = pkgs.unstable.linuxPackages_latest;
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  services.dbus.enable = true;
  services.blueman.enable = true;
  services.openssh.enable = true;
  services.openssh.permitRootLogin = "no";
  #Enable blutooth
  hardware.bluetooth.enable = true;


  # stylix.image = /home/sargo/nix-files/gruv-material-texture.png;
  
  system.stateVersion = "22.11"; # Did you read the comment?
  nixpkgs.overlays = [
    (self: super: {
      waybar = super.waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      });
    })
    mozillaOverlay
  ];
  nixpkgs.config.packageOverrides = pkgs: {
    unstable = import unstableTarball {
      config = config.nixpkgs.config;
    };
  };
  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };
  imports =
    [ 
      # (import stylix).homeManagerModules.stylix 
      ./hardware-configuration.nix
      ./sargo.nix
      ./system-pakages.nix
      (import "${home-manager}/nixos")
      hyprland.nixosModules.default
    ];
  nixpkgs.config.allowUnfree = true;
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
  
  system.autoUpgrade.enable = true;
}
