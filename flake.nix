{
  description = "Nix is love. Nix is life.";

  inputs = {
    ##########################
    # nix package sets
    # global, so they can be `.follow`ed
    systems.url = "github:nix-systems/default-linux";

    # We build against NixOS unstable, because stable takes way too long to get things into
    # more versions with or without pinned branches can be added if deemed necessary
    # stable? Never heard of her.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-small.url = "github:NixOS/nixpkgs/nixos-unstable-small"; # moves faster, has less packages

    ##########################
    # flake and system support

    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";

    templates.url = "github:nixos/templates";

    ##########################
    # extras

    niri-flake = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "unstable";
      inputs.nixpkgs-stable.follows = "nixpkgs";
    };
  };

  outputs = inputs:
    let
      lib = inputs.snowfall-lib.mkLib {
        inherit inputs;

        src = ./.;

        snowfall = {
          namespace = "dots";
          meta = {
            name = "dots";
            title = "Flake Dots";
          };
        };
      };
    in
    lib.mkFlake {
      channels-config = {
        allowUnfree = true;
      };

      overlays = with inputs; [

        niri-flake.overlays.niri

      ];

      systems.modules.nixos = with inputs; [
        disko.nixosModules.default
        impermanence.nixosModules.impermanence


        # until I work out where to put this.
       # ({ ... }: {
          # nix.registry.nixpkgs.flake = nixpkgs;
          # nix.registry.unstable.flake = unstable;
          # nix.registry.olistrik.flake = self;
          # nix.registry.templates.flake = self;

          # nix.settings = {
          #   auto-optimise-store = true;
          #  substituters = [
          #    "https://cache.olii.nl"
          #    "https://cache.nixos.org"
          #  ];
           # trusted-public-keys = [
          #    "cache.olii.nl:/eobpj1e29xJJ4r2ixYFR4E0t0zNDqu2g9/3ryaRa60="
          #    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          #  ];
         # };
       # })
      ];
    };
}
