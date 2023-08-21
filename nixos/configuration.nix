{ pkgs, ... }: {
  imports = [ ./remaps.nix ./fonts.nix ];

  systemd.watchdog.rebootTime = "10s"; 
  systemd.extraConfig = ''
    DefaultTimeoutStopSec=10s
  '';

  environment = {
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };
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
    auto-cpufreq = {
      enable = true;
      settings = {
        # settings for when connected to a power source
        charger = {
        governor = "performance";
        scaling_min_freq = 800000;# kHz
        scaling_max_freq = 4700000;# kHz
        turbo = "auto";
        };
        battery = {
          governor = "powersave";
          scaling_min_freq = 500000; # kHz
          scaling_max_freq = 1000000;# kHz
          turbo = "auto";
        };
      };
    };
    power-profiles-daemon.enable = false;
    syncthing.enable = true;
    dbus = {
      enable = true;
      # implementation = "broker";
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
    xserver = {
      enable = true;
      desktopManager = {
        xterm.enable = false;
      };
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
    platformTheme = "gnome";
    style = "adwaita-dark";
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
  };

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
