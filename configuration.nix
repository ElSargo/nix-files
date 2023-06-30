{ pkgs, system, hyprland, nuscripts, home-manager, hosts, unix-chad-bookmarks
, new-terminal-hyprland, config, ... }: {
  imports = [
    ./remaps.nix
    (import ./sargo.nix {
      inherit pkgs hyprland nuscripts config new-terminal-hyprland
        unix-chad-bookmarks;
    })
    ./fonts.nix
    (import "${home-manager}/nixos")
    hyprland.nixosModules.default
  ];

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
    systemPackages = pkgs.lib.flatten [
      (import ./system-packages.nix { inherit pkgs; })
      unix-chad-bookmarks.defaultPackage.${system}
      new-terminal-hyprland.defaultPackage.${system}
      pkgs.gnome.adwaita-icon-theme
      pkgs.eww
    ];
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

  users.defaultUserShell = pkgs.unstable.nushell;

  # Enable networking
  networking = {
    networkmanager.enable = true;
    firewall.allowedTCPPorts = [ 22 ];
    nameservers = [ "192.168.1.1" "1.1.1.1" "8.8.8.8" ];
    extraHosts = builtins.concatStringsSep "\n" [
      (builtins.readFile "${hosts}/hosts")
      "192.168.1.201 SargoLaptop"
      "192.168.1.202 SargoPi"
    ];

  };

  services = {

    #  udev.packages = [
    #   pkgs.android-udev-rules
    # ];

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
    sudo.extraRules = [{
      users = [ "sargo" ];
      commands = [{
        command = "ALL";
        options =
          [ "NOPASSWD" ]; # "SETENV" # Adding the following could be a good idea
      }];
    }];
  };

  qt = {
    enable = true;
    platformTheme = "gtk2";
    style = "gtk2";
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    # extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
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

  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart =
          "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };
  # systemd.user.services.sway-polkit-authentication-agent = {
  #   Unit = {
  #     Description = "Sway Polkit authentication agent";
  #     Documentation = "https://gitlab.freedesktop.org/polkit/polkit/";
  #     After = [ "graphical-session-pre.target" ];
  #     PartOf = [ "graphical-session.target" ];
  #   };

  #   Service = {
  #     ExecStart =
  #       "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
  #     Restart = "always";
  #     BusName = "org.freedesktop.PolicyKit1.Authority";
  #   };

  #   Install.WantedBy = [ "graphical-session.target" ];
  # };

  programs = {
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    hyprland.enable = true;
    adb.enable = true;
  };

  hardware = {
    pulseaudio.enable = false;
    bluetooth.enable = true;
    # hackrf.enable = true;
  };

  users.groups.plugdev = { members = [ "sargo" ]; };
  # users.groups.adbusers.members = [ "sargo" ];

  nixpkgs = {
    config.allowUnfree = true;
    # overlays = [
    #   (self: super: {
    #     waybar = super.waybar.overrideAttrs (oldAttrs: {
    #       mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
    #     });
    #   })
    # ];
  };

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
