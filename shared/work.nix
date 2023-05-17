# The default configuration for all systems.
# May need to be further divided in the future to allow for easier control
# of different kinds of systems.

{ config, lib, pkgs, ... }:
let

  wrapEnv = pkg: cmd: vars:
    pkgs.symlinkJoin {
      name = pkg.name;
      paths = [ pkg ];
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = builtins.concatStringsSep " --set "
        ([ "wrapProgram $out/bin/${cmd}" ]
          ++ map (var: "${var.name} ${var.value}") vars);
    };

  jetbrainsVars = [
    {
      name = "WAKATIME_CLI_LOCATION";
      value = "${pkgs.wakatime}/bin/wakatime";
    }
    {
      name = "CHROME_BIN";
      value = "${pkgs.google-chrome}/bin/google-chrome-stable";
    }
  ];

in {
  networking.extraHosts = ''
    127.0.0.1 db
    127.0.0.1 redis
  '';

  programs.adb.enable = true;

  # programs that don't need "much" configuration.
  environment.systemPackages = with pkgs; [
    # utility
    # postman
    # httpie
    # ngrok

    # communications
    (unstable.discord.override { nss = nss_latest; })
    slack-dark
    zoom-us
    teams

    # editors
    jetbrains.goland
    (jetbrains.webstorm.overrideAttrs (old: {
      version = "2022.2.1";
      src = fetchurl {
        url =
          "https://download.jetbrains.com/webstorm/WebStorm-2022.2.1.tar.gz";
        sha256 =
          "508fe7272dd049875d848b52a2908e4d228ce576d4dde5f56f51a8c346b12a2c";
      };
    }))

    # beekeeper-studio

    # unstable.poedit

    vscode

    # Docker
    docker-compose

    # JavaScript
    # cookiecutter
    # nodePackages.prettier

    # git
    kranex.rubyPackages.git-chain

    #Web Browsers
    google-chrome
    firefox

  ];

  # Docker
  virtualisation = {
    docker = {
      enable = true;
      package = (pkgs.docker.override (args: { buildxSupport = true; }));
    };
    lxd.enable = true;
  };

  users.users.kranex.extraGroups = [ "docker" ];
}
