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
    127.0.0.1 killbill
  '';

  programs.adb.enable = true;

  # programs that don't need "much" configuration.
  environment.systemPackages = with pkgs; [
    # utility
    postman
    httpie

    # communications
    unstable.discord
    zoom-us
    teams
    minecraft

    # editors

    (wrapEnv jetbrains.goland "goland" jetbrainsVars)
    (wrapEnv jetbrains.webstorm "webstorm" jetbrainsVars)
    (wrapEnv jetbrains.idea-community "idea-community" jetbrainsVars)
    unstable.poedit
    vscode

    # Docker
    docker-compose

    # JavaScript
    yarn
    nodejs
    nodePackages."@angular/cli"
    nodePackages.prettier

    # C & C++
    gcc10
    gdb
    valgrind
    binutils

    # Go
    unstable.go_1_18
    air
    altair

    #Web Browsers
    google-chrome
    firefox

    # Database cli's
    mycli
    pgcli
    litecli

    # Time Keeping
    wakatime
  ];

  # wakatime variables
  environment.variables.WAKATIME_BIN = "${pkgs.wakatime}/bin/wakatime";

  # Docker
  virtualisation.docker = {
    enable = true;
    package = (pkgs.docker.override (args: { buildxSupport = true; }));
  };

  users.users.kranex.extraGroups = [ "docker" ];
}
