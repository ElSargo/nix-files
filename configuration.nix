{ config, pkgs, ... }:
let
  home-manager = fetchGit {
    url = "https://github.com/nix-community/home-manager";
    rev = "6142193635ecdafb9a231bd7d1880b9b7b210d19";
  };

  # unstableChannel = fetchGit {
  #   url = "https://github.com/NixOS/nixpkgs/";
  #   rev = "c1a1e9fa3d70c347da5bc6f09b56d4b8345215a2";
  # };
  # flake-compat = fetchGit {
  #   url = "https://github.com/edolstra/flake-compat/";
  #   rev = "35bb57c0c8d8b62bbfd284272c928ceb64ddbde9";
  # };

  unstableTarball = fetchTarball
    "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";

  flake-compat = fetchTarball
    "https://github.com/edolstra/flake-compat/archive/master.tar.gz";

  hyprland = (import flake-compat {
    src = fetchGit {
      url = "https://github.com/hyprwm/Hyprland";
      rev = "edad24c257c1264e2d0c05b04798b6c90515831e";
    };
  }).defaultNix;

in {
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  #//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  # User setup
  #//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  users.defaultUserShell = pkgs.fish;

  # Enable networking
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
    displayManager = { defaultSession = "hyprland"; };
    libinput.enable = true;
    excludePackages = [ pkgs.xterm pkgs.gnome.gnome-terminal ];
    layout = "us";
  };

  qt5.enable = true;
  qt5.platformTheme = "gtk2";
  qt5.style = "gtk2";
  xdg.portal.wlr.enable = true;

  services.printing.enable = true;

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
  security.sudo.extraRules = [{
    users = [ "sargo" ];
    commands = [{
      command = "ALL";
      options =
        [ "NOPASSWD" ]; # "SETENV" # Adding the following could be a good idea
    }];
  }];

  boot.binfmt.emulatedSystems =
    [ "wasm32-wasi" "x86_64-windows" "aarch64-linux" ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.initrd.secrets = { "/crypto_keyfile.bin" = null; };
  boot.initrd.luks.devices."luks-4955bc2c-1e9b-4a8b-ab6d-125ca5b3e064".device =
    "/dev/disk/by-uuid/4955bc2c-1e9b-4a8b-ab6d-125ca5b3e064";
  boot.initrd.luks.devices."luks-4955bc2c-1e9b-4a8b-ab6d-125ca5b3e064".keyFile =
    "/crypto_keyfile.bin";
  boot.kernelPackages = pkgs.unstable.linuxPackages_latest;
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  services.dbus.enable = true;
  services.blueman.enable = true;
  services.openssh.enable = true;
  services.openssh.permitRootLogin = "no";
  hardware.bluetooth.enable = true;

  system.stateVersion = "22.11";
  nixpkgs.overlays = [
    (self: super: {
      waybar = super.waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      });
    })
  ];

  nixpkgs.config.packageOverrides = pkgs: {
    unstable = import unstableTarball { config = config.nixpkgs.config; };
  };

  imports = [
    ./hardware-configuration.nix
    (import ./sargo.nix { inherit pkgs hyprland; })
    ./system-packages.nix
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
  programs.hyprland.enable = true;

}
