{ lib, config, ... }:
with lib;
with lib.dots;
let
  cfg = config.dots.tools.direnv;
in
{
  options.dots.tools.direnv = {
    enable = mkEnableOption "direnv";
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
    programs.direnv.enable = true;

    dots.programs.zsh = mkIf cfg.shellHooks.zsh.enable {
      extraConfig = ''eval "$(${config.programs.direnv.package}/bin/direnv hook zsh)"'';
    };
  };
}

