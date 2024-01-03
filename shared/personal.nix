# These are programs and their configs that I want on personal systems but are
# not needed on servers etc.
{ config, lib, pkgs, ... }: {
  imports = [ ./programs/alacritty.nix ];

  programs.adb.enable = true;

  environment.systemPackages = with pkgs; [
    steam-run # for shit software

    # media
    spotify
    feh
    mplayer
    zathura

    # editing
    gimp

    # browsers
    google-chrome

    # keyboard
    dfu-util

    bitwarden
    bitwarden-cli
    unstable.bws
  ];

  services.udev.extraRules = ''
        ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", MODE="664", GROUP="plugdev"
    	KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0664", GROUP="plugdev"
  '';
}
