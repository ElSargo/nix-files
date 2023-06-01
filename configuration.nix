{ pkgs, system, hyprland, nuscripts, home-manager, hosts, unix-chad-bookmarks
, config, ... }: {
  imports = [
    ./remaps.nix
    (import ./sargo.nix { inherit pkgs hyprland nuscripts config; })
    ./fonts.nix
    (import "${home-manager}/nixos")
    hyprland.nixosModules.default
  ];

  environment.systemPackages = pkgs.lib.flatten [
    (import ./system-packages.nix { inherit pkgs; })
    unix-chad-bookmarks.defaultPackage.${system}
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  users.defaultUserShell = pkgs.unstable.nushell;

  # Enable networking
  networking.firewall.allowedTCPPorts = [ 22 ];
  networking.networkmanager.enable = true;
  networking.nameservers = [ "192.168.1.1" "1.1.1.1" "8.8.8.8" ];
  networking.extraHosts = builtins.concatStringsSep "\n" [
    (builtins.readFile "${hosts}/hosts")
    "192.168.1.201 SargoLaptop"
    "192.168.1.202 SargoPi"
  ];
  services.flatpak.enable = true;
  security.polkit.enable = true;
  services.power-profiles-daemon.enable = false;
  services.tlp.enable = true;
  services.xserver = {
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

  qt.enable = true;
  qt.platformTheme = "gtk2";
  qt.style = "gtk2";
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
  boot.loader.grub.configurationLimit = 10;
  boot.tmp.cleanOnBoot= true;
  # Setup keyfile
  boot.initrd.secrets = { "/crypto_keyfile.bin" = null; };

  # Enable swap on luks

  boot.kernelPackages = pkgs.unstable.linuxPackages_latest;
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  services.dbus.enable = true;
  services.blueman.enable = true;
  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = "no";
  hardware.bluetooth.enable = true;

  nixpkgs.overlays = [
    (self: super: {
      waybar = super.waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      });
    })
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
  system.stateVersion = "23.05";
}
