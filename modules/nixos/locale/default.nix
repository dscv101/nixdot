{ lib, config, ... }:
with lib;
with lib.dots;
let
  cfg = config.dots.locale;
in
{
  options.dots.locale = with types; {
    timeZone = mkOpt str "America/Chicago" "The system timezone.";
    defaultLocale = mkOpt str "en_US.UTF-8" "The default language/locale.";
    formatLocale = mkOpt str "en_US.UTF-8" "The locale for time, number, address, etc formats.";
  };

  config = {
    time.timeZone = mkDefault cfg.timeZone;

    i18n = {
      defaultLocale = mkDefault cfg.defaultLocale;
      extraLocaleSettings = builtins.listToAttrs
        (map
          (name: {
            inherit name;
            value = mkDefault cfg.formatLocale;
          }) [
          "LC_ADDRESS"
          "LC_IDENTIFICATION"
          "LC_MEASUREMENT"
          "LC_MONETARY"
          "LC_NAME"
          "LC_NUMERIC"
          "LC_PAPER"
          "LC_TELEPHONE"
          "LC_TIME"
        ]);
    };
  };
}
