{ lib, config, pkgs, ... }:
with lib;
with lib.dots;
let
  cfg = config.dots.programs.zoxide;
in
{
  options.dots.programs.zoxide = {
    enable = mkEnableOption "zoxide";
    package = mkOpt types.package pkgs.zoxide "zoxide package";
    # TODO: lib this for all shells, etc.
    shellHooks = mkSub "config for shell hooks" {
      zsh = mkSub "config for zsh" {
        enable = mkEnableOption "zsh hook" // {
          default = config.dots.programs.zsh.enable;
        };
      };
    };
  };

  config = mkIf cfg.enable {
    # TODO: work out how to drop the global install of zoxide;
    # the init script assumes it's on the path.
    environment.systemPackages = [ cfg.package ];

    dots.programs.zsh = mkIf cfg.shellHooks.zsh.enable {
      extraConfig = ''eval "$(${cfg.package}/bin/zoxide init zsh)"'';
    };
  };
}
