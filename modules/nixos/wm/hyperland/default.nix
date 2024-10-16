{ lib, config, pkgs, ... }:
with lib;
with lib.dots;
let
  cfg = config.dots.wm.hyperland;
in
{
  options.dots.wm.hyperland = {
    enable = mkEnableOption "hyprland";
  };

  config = mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
    };

    dots.programs = {
      waybar = enabled;
      # way-displays = enabled;
    };

    security.pam.services.swaylock = { };

    xdg.portal = {
      enable = true;
      # wxdgOpenUsePortal = true;
      # hyprland installs it's own portal.
    };

    services.greetd = {
      enable = true;
      settings = rec {
        initial_session = {
          command = "${config.programs.hyprland.package}/bin/Hyprland";
          user = "dscv";
        };
        default_session = initial_session;
      };
    };

    environment.systemPackages = with pkgs; [
      # wallpaper, lockscreen, and idler.
      hyprpaper
      hyprlock
      hypridle

      # notifications.
      dunst

      # program launcher.
      wofi

      # screensharing.
      grim
      jq
      slurp

      # media controls, etc.
      playerctl
      wl-clipboard

      # cross support (hyprland installs xwayland).
      xwaylandvideobridge

      # remove
      swaylock
      swayidle
    ];

    environment.sessionVariables.NIXOS_OZONE_WL = "1";
  };
}
