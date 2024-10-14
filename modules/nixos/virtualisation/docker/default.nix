{ lib, config, pkgs, ... }:
with lib;
with lib.dots;
let
  cfg = config.dots.virtualisation.docker;
in
{
  options.dots.virtualisation.docker = with types; {
    enable = mkEnableOption "docker";
    rootless = mkEnableOption "rootless mode";
    buildx = mkEnableOption "buildx support";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.docker-compose ];

    virtualisation.docker = {
      enable = true;
      package = mkIf cfg.buildx (pkgs.docker.override (args: { buildxSupport = true; }));
      rootless = mkIf cfg.rootless {
        enable = true;
        setSocketVariable = true;
      };
    };

    dots.user.extraGroups = mkIf (! cfg.rootless) [ "docker" ];
  };
}
