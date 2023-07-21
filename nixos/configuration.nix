{ pkgs, ... }: {
  imports = [ ./remaps.nix ./fonts.nix ];

  environment = {
    gnome.excludePackages = with pkgs.gnome; [
      cheese # webcam tool
      gnome-music
      gnome-terminal
      gedit # text editor
      epiphany # web browser
      tali # poker game
      iagno # go game
      hitori # sudoku game
      atomix # puzzle game
    ];
    systemPackages =
      pkgs.lib.flatten [ (import ./system-packages.nix { inherit pkgs; }) ];
  };

  nix = {
    settings = {
      warn-dirty = false;
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
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

    blueman.enable = true;
    cpupower-gui.enable = true;
    dbus = {
      enable = true;
      implementation = "broker";
    };
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
    upower.enable = true;
    xserver = {
      enable = true;
      desktopManager = {
        xterm.enable = false;
        gnome.enable = true;
      };
      displayManager.gdm.enable = true;
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

  qt = {
    enable = true;
    platformTheme = "gtk2";
    style = "gtk2";
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
  };

  sound.enable = true;

  # Bootloader.
  boot = {
    binfmt.emulatedSystems = [ "wasm32-wasi" "x86_64-windows" "aarch64-linux" ];
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    loader.efi.efiSysMountPoint = "/boot/efi";
    loader.grub.configurationLimit = 10;
    tmp.cleanOnBoot = true;
    initrd.secrets = { "/crypto_keyfile.bin" = null; };
    kernelPackages = pkgs.unstable.linuxPackages_latest;
  };

  programs = {
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    hyprland.enable = true;
  };

  hardware = {
    pulseaudio.enable = false;
    bluetooth.enable = true;
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
