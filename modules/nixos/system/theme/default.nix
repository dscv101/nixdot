{ lib, ... }:
with lib; {
  options.dots.system.theme = {
    theme = mkOption {
      type = types.attrs;
      default = import ./ayu-mirage.nix;
    };
  };
}
