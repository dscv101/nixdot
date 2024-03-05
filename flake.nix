{
  description = "Nix is love. Nix is life.";

  inputs = {

    # Normal nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";

    # Unstable nixpkgs
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # snowfall
    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # templates
    templates.url = "github:nixos/templates";

    # Hyprland WM
    hyprland.url = "github:hyprwm/Hyprland/v0.34.0";

    # Nixvim
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "unstable";
    };

    steam-fetcher = {
      url = "github:nix-community/steam-fetcher";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs:
    let
      lib = inputs.snowfall-lib.mkLib {
        inherit inputs;

        src = ./.;

        snowfall = {
          namespace = "olistrik";
          meta = {
            name = "olistrik";
            title = "Flake stuff from Oli Strik 😊";
          };
        };

      };
    in
    lib.mkFlake {
      channels-config = {
        allowUnfree = true;
      };

      nixvimModules = lib.snowfall.module.create-modules {
        src = "${./modules/nixvim}";
      };

      overlays = with inputs; [
        steam-fetcher.overlays.default
        nixvim.overlays.default
      ];

      systems.modules.nixos = with inputs; [
        hyprland.nixosModules.default
        # until I work out where to put this.
        ({ ... }: {
          nix.registry.nixpkgs.flake = nixpkgs;
          nix.registry.unstable.flake = unstable;
          nix.registry.olistrik.flake = self;
          nix.registry.templates.flake = self;

          nix.settings = {
            auto-optimise-store = true;
            substituters = [
              "https://cache.nixos.org/"
              "https://hyprland.cachix.org"
            ];
            trusted-public-keys = [
              "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
              "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
            ];
          };
        })
      ];
    };
}
