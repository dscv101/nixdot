{ pkgs, ... }: {
  imports = [
    ./node-red/extra-nodes.nix
  ];
  services = {
    mosquitto = {
      enable = true;
      listeners = [
        {
          acl = [ "pattern readwrite #" ];
          users = {
            zigbee = {
              passwordFile = "/var/lib/mosquitto/zigbee@mqtt.pass";
            };
          };
        }
      ];
    };

    zigbee2mqtt = {
      enable = true;
      settings = {
        serial = {
          port = "/dev/ttyUSB0";
        };
        mqtt = {
          server = "mqtt://localhost:1883";
          user = "zigbee";
          password = "!secret.yaml password";
        };
        advanced = {
          network_key = "!secret.yaml network_key";
        };
        frontend = true;
      };
    };

    esphome = {
      enable = true;
      openFirewall = true;
    };

    node-red = {
      enable = true;
    };

    nixwarden.secrets = {
      "zigbee@mqtt.pass" = [{
        location = "/var/lib/mosquitto/zigbee@mqtt.pass";
        wantedBy = [ "mosquitto.service" ];
        userGroup = "mosquitto:mosquitto";
      }];
      "zigbee2mqtt-secret.yaml" = [{
        location = "/var/lib/zigbee2mqtt/secret.yaml";
        wantedBy = [ "zigbee2mqtt.service" ];
        userGroup = "zigbee2mqtt:zigbee2mqtt";
      }];
    };

    nginx = {
      enable = true;
      recommendedProxySettings = true;
      virtualHosts = {
        "zigbee.olii.nl" = {
          forceSSL = true;
          useACMEHost = "olii.nl";
          extraConfig = ''
            proxy_buffering off;
          '';
          locations = {
            "/" = {
              proxyPass = "http://localhost:8080";
              proxyWebsockets = true;
            };
            "/api" = {
              proxyPass = "http://localhost:8080/api";
              proxyWebsockets = true;
            };
          };
        };
        "node-red.olii.nl" = {
          forceSSL = true;
          useACMEHost = "olii.nl";
          extraConfig = ''
            proxy_buffering off;
          '';
          locations = {
            "/" = {
              proxyPass = "http://localhost:1880";
              proxyWebsockets = true;
            };
          };
        };
        "home.olii.nl" = {
          forceSSL = true;
          useACMEHost = "olii.nl";
          extraConfig = ''
            proxy_buffering off;
          '';
          locations = {
            "= /" = {
              extraConfig = ''
                rewrite ^ /dashboard;
              '';
            };
            "/" = {
              proxyPass = "http://localhost:1880";
              proxyWebsockets = true;
            };
          };
        };
      };
    };
  };
}
