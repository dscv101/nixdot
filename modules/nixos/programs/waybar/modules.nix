{ pkgs }:
{
  workspaces = {
    name = "hyprland/workspaces";
    style = ''
      #workspaces {
          margin: 4px 2px;
          padding: 0px 0px;
          background-color: rgba(43, 48, 59, 0.8);
          border-radius: 4px;
      }

      #workspaces button:first-child {
        border-radius: 4px 0 0 4px;
      }

      #workspaces button:last-child {
        border-radius: 0 4px 4px 0;
      }

      #workspaces button {
          padding: 0 5px;
          background-color: transparent;
          color: #ffffff;
          box-shadow: inset 0 -3px transparent;
      }

      #workspaces button:hover {
          background: rgba(0, 0, 0, 0.2);
          box-shadow: inset 0 -1px #ffffff;
      }

      #workspaces button.visible {
          background-color: rgba(255, 255, 255, 0.1);
          box-shadow: inset 0 -1px #cccccc;
      }

      #workspaces button.current_output.focused {
        background-color: #64727D;
          box-shadow: inset 0 -1px #ffffff;
      }

      #workspaces button.urgent {
          background-color: #eb4d4b;
      }
    '';
  };

  mode = {
    name = "sway/mode";
    config = ''
      "sway/mode": {
          "format": "<span style=\"italic\">{}</span>"
      },
    '';
    style = ''
      #mode {
          background-color: #64727D;
          /* border-bottom: 3px solid #ffffff; */
      }
    '';
  };

  window = {
    name = "hyprland/window";
    style = ''
      #window {
        margin: 4px 2px;
        min-width: 200px;
        padding: 0 20px;
        background-color: rgba(43, 48, 59, 0.8);
        border-radius: 4px;
      }
      window#waybar.empty #window {
        background-color: rgba(0,0,0,0);
      }
    '';
  };

  clock = {
    name = "clock";
    config = ''
      "clock": {
          // "timezone": "america/new_york",
          "tooltip-format": "<big>{:%y %b}</big>\n<tt><small>{calendar}</small></tt>",
          "format-alt": "{:%y-%m-%d}"
      },
    '';
    style = ''
      #clock {
      }
    '';

  };

  network = {
    name = "network";
    config = ''
      "network": {
          // "interface": "wlp2*", // (Optional) To force the use of this interface
          "format-wifi": "  {signalStrength}%",
          "format-ethernet": "󰈀  {ipaddr}/{cidr}",
          "format-linked": "  {ifname} (No IP)",
          "format-disconnected": "⚠ Disconnected",
          "format-alt": "{ifname} {ipaddr}/{cidr}"
      },
    '';
    style = ''
      #network {
      }

      #network.disconnected {
      }
    '';
  };

  pulseaudio = {
    name = "pulseaudio";
    config = ''
      "pulseaudio": {
          // "scroll-step": 1, // %, can be a float
          "format": "{icon}  {volume}% {format_source}",
          "format-bluetooth": "{icon}  {volume}% {format_source}",
          "format-bluetooth-muted": " {icon}  {format_source}",
          "format-muted": "  {format_source}",
          "format-source": "",
          "format-source-muted": "",
          "format-icons": {
              "headphone": "",
              "hands-free": "",
              "headset": "",
              "phone": "",
              "portable": "",
              "car": "",
              "default": ["", "", ""]
          },
          "on-click": "pavucontrol"
      },
    '';
    style = ''
      #pulseaudio {
      }

      #pulseaudio.muted {
      }
    '';
  };

  idleInhibitor = {
    name = "idle_inhibitor";
    style = ''
      #idle_inhibitor {
      }

      #idle_inhibitor.activated {
      }
    '';
  };

  gitlab-issues = {
    name = "custom/gitlab-issues";
    config = ''
      "custom/gitlab-issues": {
        "return-type": "json",
        "exec": "${pkgs.dots.waybar-gitlab}/bin/waybar-gitlab issues",
        "on-click": "${pkgs.dots.waybar-gitlab}/bin/waybar-gitlab issues open"
      },
    '';
  };
  gitlab-merge-requests = {
    name = "custom/gitlab-merge-requests";
    config = ''
      "custom/gitlab-merge-requests": {
        "return-type": "json",
        "exec": "${pkgs.dots.waybar-gitlab}/bin/waybar-gitlab merge-requests",
        "on-click": "${pkgs.dots.waybar-gitlab}/bin/waybar-gitlab merge-requests open"
      },
    '';
  };
}
