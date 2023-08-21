{ config, lib, modulesPath, pkgs, ... }: {
  # networking.defaultGateway = "192.168.1.200";
  networking.hostName = "SargoSummit"; # Define your hostname.
  services.acpid.enable = true;
  # Bootloader.
  boot = {
    tmp.useTmpfs = true;
    binfmt.emulatedSystems = [ "wasm32-wasi" "x86_64-windows" "aarch64-linux" ];
    loader.grub.configurationLimit = 10;
    tmp.cleanOnBoot = true;
    kernelPackages = pkgs.unstable.linuxPackages_latest;
    # kernelParams = ["quiet"];
  };

  systemd.services.mcontrolcenter = {
    description = "test Daemon";
    serviceConfig = {
      Name = "mcontrolcenter.helper";
      Exec = "/home/sargo/MControlCenter/helper/mcontrolcenter-helper";
      User = "root";
    };
    enable = true;
  };

  #////////////////////////////////////////////////////////////////////
  # From /etc/nixos/configuration.nix
  #////////////////////////////////////////////////////////////////////
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  #////////////////////////////////////////////////////////////////////
  # From /etc/nixos/hardware-configuration.nix
  #////////////////////////////////////////////////////////////////////
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "thunderbolt"
    "nvme"
    "usb_storage"
    "usbhid"
    "sd_mod"
    "rtsx_pci_sdmmc"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" "acpi_ec" "ec_sys" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/ab032e3a-09d1-43eb-85df-1b6ea66d99eb";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/DDFD-8F0E";
    fsType = "vfat";
  };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/05609abd-53d1-4a7e-a6c2-6b25e80867a3"; }];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.eth0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlo1.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;
  #////////////////////////////////////////////////////////////////////
  # End of /etc/nixos/hardware-configuration.nix
  #////////////////////////////////////////////////////////////////////
}
