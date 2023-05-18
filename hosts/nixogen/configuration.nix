{ config, pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix

    ../../shared/workstation.nix
    ../../shared/personal.nix
    ../../shared/work.nix
    ../../shared/yubikey.nix
    ../../shared/wm/sway
  ];

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  ##################
  ## Work specific

  # Work devices are "Other non metals" and this one is running Nixos.
  # Nixos + Nitrogen = Nixogen.
  networking.hostName = "nixogen";

  # Use the systemd-boot EFI boot loader.
  boot = {
    loader = {
      # Use Systemd-boot. Grub really doesn't like LUKS.
      systemd-boot.enable = true;
      # Change the EFI mount point to "/boot/efi"
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };

    };
    kernel.sysctl = { "fs.inotify.max_user_watches" = "1048576"; };
    ## Mark /dev/nvme2 as luks.
    initrd.luks.devices = {
      root = {
        device = "/dev/disk/by-uuid/affa3eb4-7e3f-4a0e-9c7e-bdcd46777c51";
        preLVM = true;
      };
    };
  };

  ####################
  ## Laptop Specific
  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };

  hardware.opengl = {
    enable = true;
    driSupport = true;
    extraPackages = with pkgs; [ vaapiVdpau libvdpau-va-gl ];
  };

  hardware.bluetooth = {
    enable = true;
    settings.General = {
      Enable = "Source,Sink,Media,Socket";
      Disable = "Headset";
    };
  };

  # Enable laptop touchpad.
  services.xserver.libinput.mouse = { accelSpeed = "-0.85"; };

  # Enables wireless support via wpa_supplicant.
  networking.wireless = {
    enable = true;
    interfaces = [ "wlp60s0" ];
  };

  networking.useDHCP = false;
  networking.interfaces.enp0s31f6.useDHCP = true;
  networking.interfaces.wlp60s0.useDHCP = true;

  # environment.variables.WINIT_X11_SCALE_FACTOR = "1.25";

  #################
  ## Localisation

  # Locale
  time.timeZone = "Europe/Amsterdam";

  # Terminal keymap and font.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  ## set X11 localisation
  services.xserver = {
    layout = "us";
    xkbOptions = "eurosign:5";
  };

  ################
  ## Theming WIP

  system.themer = {
    theme = import ../../shared/themes/ayu-mirage.nix;
    wm = {
      gaps = {
        inner = 5;
        outer = -4;
      };
    };
  };

  programs.alacritty = {
    font.size = "10.0";
    theme = config.system.themer.theme;
    window.opacity = "0.95";
  };

  programs.openvpn3.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?

}
