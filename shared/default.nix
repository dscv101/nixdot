# The default configuration for all systems.
# May need to be further divided in the future to allow for easier control
# of different kinds of systems.

{ config, lib, pkgs, ... }:

let

  inherit (lib.modules) mkDefault;

in

{

  imports = [
    ../modules
    ./users.nix
    ./services.nix
    ./ssh.nix
    ./audio.nix
    ./programs/zsh.nix
    ./programs/neovim.nix
  ];

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [

    nix-index

    # dependencies
    libpng12

    # misc
    killall
    zip
    unzip

    # for the lolz
    lolcat
    sl

    # compilers
    gcc10
    gnumake
    cmake

    # Net sync.
    wget
    git

    # Document viewers.
    feh
    zathura

    #bspwm stuff
    polybar
    dmenu
    sxhkd
    compton
    neofetch
    imagemagick
    xdotool

    #Web Browser
    vivaldi-ffmpeg-codecs
    vivaldi-widevine
    (vivaldi.override {
      proprietaryCodecs = true;
      vivaldi-ffmpeg-codecs = pkgs.vivaldi-ffmpeg-codecs;
      enableWidevine = true;
      vivaldi-widevine = pkgs.vivaldi-widevine;
    })
  ];

  networking.hostName = mkDefault "nixos"; # Define your hostname.
  
  # Select internationalisation properties.
  i18n.defaultLocale = mkDefault "en_US.UTF-8";
  console = mkDefault {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Set your time zone.
  time.timeZone = mkDefault "Europe/Amsterdam";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = mkDefault false;
  # networking.interfaces.enp0s3.useDHCP = mkDefault true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = mkDefault "20.03"; # Did you read the comment?
}

