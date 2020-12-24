{config, lib, pkgs, ...}:

with lib;

let
  themer = config.system.themer;
  cfg = config.services.xserver.windowManager.i3;
in
  {
    imports = [
      ./programs/picom.nix
      ./programs/i3lock.nix
    ];

    config = {

      environment.etc."xdg/i3status/config".source = ../../dots/i3status.conf;

      services.xserver = {
        enable = true;

        desktopManager = {
          xterm.enable = false;
        };

        displayManager = {
          defaultSession = "none+i3";
          lightdm.greeters.mini = {
            enable = true;
            user = "kranex";
            extraConfig = ''
              [greeter]
              show-password-label = false
              [greeter-theme]
              background-color = "#303030"
              background-image = "/etc/lightdm/background.jpg"
              window-color ="#000000"
            '';
          };
        };

        windowManager.i3 = {
          enable = true;
          package = pkgs.i3-gaps;

          extraPackages = with pkgs; [
            rofi
            polybar
            i3status
            i3blocks
          ];

          configFile = (
            pkgs.writeText "i3-config" (''
                ################################################
                ##  i3 cnfig   #################################
                ################################################

                # Set modifier key to windows
                set $mod Mod4

                # set gaps
                gaps inner ${builtins.toString themer.wm.gaps.inner}
                gaps outer ${builtins.toString themer.wm.gaps.outer}

                # Set font
                font pango:JetBrains Mono NerdFont Mono 8

                # Move floating windows with Mouse + MOD
                floating_modifier $mod

                # Set workspace names
                set $ws1 "1"
                set $ws2 "2"
                set $ws3 "3"
                set $ws4 "4"
                set $ws5 "5"

                # hide window titles
                for_window [class="^.*"] border pixel 2

                ################################################
                ## Keybindings #################################
                ################################################

                #############
                ## General

                # kill focus window
                bindsym $mod+Shift+q kill

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

                # lock i3
                bindsym $mod+Shift+l exec xautolock -locknow

                #############
                ## Programs

                # Alacritty Terminal
                bindsym $mod+Return exec alacritty

                # dmenu
                bindsym $mod+space exec rofi -theme Arc-Dark -show run

                #######################
                ## container Controls

                # change layout
                bindsym $mod+s layout stacking
                bindsym $mod+t layout tabbed
                bindsym $mod+e layout default

                # send container to workspace
                bindsym $mod+Shift+exclam     move container to workspace number $ws1
                bindsym $mod+Shift+at         move container to workspace number $ws2
                bindsym $mod+Shift+numbersign move container to workspace number $ws3
                bindsym $mod+Shift+dollar     move container to workspace number $ws4
                bindsym $mod+Shift+percent    move container to workspace number $ws5

                ###############################################

                exec_always --no-startup-id $HOME/.config/polybar/launch.sh
              ''
            )
          );
        };
      };
    };
  }
