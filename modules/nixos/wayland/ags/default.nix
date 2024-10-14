{ lib, config, pkgs, ... }:
with lib;
with lib.dots;
let
  cfg = config.dots.wayland.ags;
in
{
  options.dots.wayland.ags = {
    enable = mkOpt types.bool false "Whether to enable AGS widgets.";
    package = mkOpt types.package pkgs.ags "Which AGS package to use.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      cfg.package
    ];
  };
}
