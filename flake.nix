{
  description = "Nix is love. Nix is life.";

  inputs = {
    # Normal nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-21.11";

    # Unstable nixpkgs
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    mkdocs-klippa.url = "git+ssh://git@git.hub.klippa.com/klippa/MkDocs.git?ref=development";

    flake-utils.url = "github:numtide/flake-utils";
  };

   outputs = {self, nixpkgs, flake-utils, ... }@inputs:
   let
    # might want these in the future.
    # inherit (builtins) toPath;
    # inherit (nixpkgs) lib;
    # inherit (lib) genAttrs;

    # overlays on nixpkgs.
    nixpkgsConfig = with inputs; rec {
      config = { allowUnfree = true; };
      overlays = [
        (
          final: prev: {
            # pkgs.unstable
            unstable = import nixpkgs-unstable {
              inherit (prev) system; inherit config;
            };

            # pkgs.kranex
            kranex = import nixpkgs {
              inherit (prev) system; inherit config; inherit (self) overlays;
            };

            # Packages to be on bleeding edge. TODO: when unstable is fixed.
            # vimPlugins = prev.vimPlugins // final.unstable.vimPlugins // final.kranex.vimPlugins;
          }
        )
      ];
    };

    pin-flake-reg = with inputs; {
      nix.registry.nixpkgs.flake = nixpkgs;
      nix.registry.unstable.flake = nixpkgs-unstable;
      nix.registry.kranex.flake = self;
    };

    # modules that are shared between all hosts.
    commonModules = with self.modules; [
      ./shared/default.nix # default programs and config for all systems.

      # my custom modules.
      programs.alacritty

      # pin the pkgs.
      pin-flake-reg

      # add the overlays.
      ({config, lib, ...}: { nixpkgs = nixpkgsConfig; })
    ];

    # shortcut for x86-64 linux systems.
    linux64 = host: nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = commonModules ++ [
        (./. + "/hosts/${host}/configuration.nix")
      ];
    };
  in {
    # My systems.
    nixosConfigurations = {
      ## Work Lenovo E15
      nixogen = linux64 "nixogen";
      ## Home Desktop
      nixium = linux64 "nixium";
      ## WSL 2
      winix = linux64 "winix";
    };

    # My overlays, see nixpkgsConfig for usage.
    overlays = with inputs; [
      (final: prev: {
        rubocop-sdv = final.callPackage ./pkgs/programs/rubocop-sdv {};
        screencapture-scripts = final.callPackage ./pkgs/scripts/screencapture {};
        code-with-me = final.callPackage ./pkgs/programs/code-with-me {};
        git-graph = final.callPackage ./pkgs/programs/git-graph {};

        klippa = {
          mkdocs-klippa = mkdocs-klippa.packages.${prev.system}.mkdocs-klippa;
        };

        vimPlugins = {
          nvim-ts-autotag = final.callPackage ./pkgs/vimPlugins/nvim-ts-autotag {};
        };

        nodePackages = final.callPackage ./pkgs/node-packages {};
      })
    ]; # ++ map import (./overlays)

    # My modules, see commonModules for usage.
    modules = {
      programs.alacritty = import ./modules/programs/alacritty;
    };
  } // flake-utils.lib.eachDefaultSystem ( system: {
    legacyPackages = (import nixpkgs {
      inherit system; inherit (nixpkgsConfig) config overlays;
    }).kranex;
  });
}
