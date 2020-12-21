{config, pkgs, ...}:

{
  services.xserver = {
    enable = true;

    desktopManager = {
      xterm.enable = false;
    };

    displayManager = {
      defaultSession = "none+i3";
    };

    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;

      extraPackages = with pkgs; [
        dmenu
        i3lock
        i3status
      ];

      config = pkgs.writeFile "i3-config" ''
        set $mod Mod4

        # Set font for window titles.
        font desktopManager

        # Lock screen before suspend
        exec --no-startup-id xss-lock --transfer-sleep-lock -- i3lock --nofork

        # Move floating windows with Mouse + MOD
        floating_modifier $mod

        # Set workspace names
        set $ws1 "1"
        set $ws2 "2"
        set $ws3 "3"
        set $ws4 "4"
        set $ws5 "5"

        # Configure bar

        bar {
          status_command i3status
        }
        ################################################
        ################################################
        ## Keybindings #################################
        ################################################

        #############
        ## General

        # kill focus window
        bindsym $mod+q kill

        # switch workspace
        bindsym $mod+1 workspace number $ws1
        bindsym $mod+2 workspace number $ws2
        bindsym $mod+3 workspace number $ws3
        bindsym $mod+4 workspace number $ws4
        bindsym $mod+5 workspace number $ws5

        # reload the config
        bindsym $mod+Shift+c reload

        # restart i3
        bindsym $mod+Shift+r restart

        # exit i3 (logs you out of your X session)
        bindsym $mod+Shift+e exec "i3-nagbar -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.' -B 'Yes, exit i3' 'i3-msg exit'"

        #############
        ## Programs

        # Alacritty Terminal
        bindsym $mod+Return exec alacritty

        # dmenu
        bindsym $mod+space exec dmenu

      '';
    };
  };
}
