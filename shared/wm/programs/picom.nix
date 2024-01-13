{ config, ... }:
{
  services = {
    picom = {
      enable = true;
      vSync = true;
      fade = true;
      inactiveOpacity = 0.7;
      opacityRules = [
        "100:class_g *= 'Firefox'"
        "100:class_g *= 'Google-chrome'"
        "100:class_g *= 'Vivaldi'"
        "100:class_g *= 'i3lock'"
        "100:class_g *= 'GIMP'"
      ];
      settings = {
        blur-background = true;
        blur-method = "gaussian";
        blur-size = 12;
        blur-kern = "3x3box";
      };
    };
  };
}
