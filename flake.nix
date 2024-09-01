{
  description = "vsiles' Nix configuration flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    { nixpkgs
    , darwin
    , home-manager
    , nixvim
    , ...
    }:
    let
      username = "vsiles";
      actualName = "Vincent Siles";
      email = "vincent.siles@ens-lyon.org";
      allowUnfree = true; # allow unfree packages to be installed

      specialArgs = { inherit username actualName email nixvim; };

      mac =
        let
          mac-specialArgs = specialArgs // { home = "/Users/${username}"; };
        in
        darwin.lib.darwinSystem {
          specialArgs = mac-specialArgs;
          modules = [
            ./system.nix
            home-manager.darwinModules.home-manager
            {
              # Ignore these properties, plz!
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = false;

              # nix supports variable interpolation with the ${} syntax in strings and sometimes elsewhere!
              home-manager.users.${username} = {
                imports = [ ./home.nix ];
              };

              # nix allows nested properties to be set in two ways - in an object style and a path style. The path style can
              # be seen with home-manager.users.${username} on the lines above. The object style
              # on the line below. A hybrid of the two usually makes sense!
              nixpkgs = {
                # an overlay is a function which adjusts the set of nixpkgs dependencies, either by
                # changing or adding more. Here, helpkgs could be adding some new dependencies,
                # or overwriting them (e.g. changing default Python to use a different optimisation level).
                overlays = [];
                config.allowUnfree = allowUnfree;
              };

              # inherit means that a variable is directly copied from a parent variable.
              # this attribute means that when home-manager calls our 'home.nix' file, it will pass these
              # arguments so that we can reference them.
              home-manager.extraSpecialArgs = mac-specialArgs;
            }
          ];
        };

      linuxPkgs = import nixpkgs {
        system = "x86_64-linux";
        overlays = [];
        config.allowUnfree = allowUnfree;
      };
      linux = home-manager.lib.homeManagerConfiguration {
        pkgs = linuxPkgs;
        modules = [
          ./home.nix
          {
            home.username = username;
            home.homeDirectory = "/home/${username}";
          }
        ];
        extraSpecialArgs = specialArgs;
      };
    in
    {
      darwinConfigurations = { inherit mac; };
      homeConfigurations = { inherit linux; };

      # by building this in checks, we will have a CI flow that works nicely.
      # here, the aarch64-darwin means that this will only be built on that architecture.
      # there is a library called 'flake-utils' which lets one define the same derivation
      # for every architecture. Here, our derivation is mac-dependent, so it doesn't really matter.
      checks.aarch64-darwin = { canBuild = mac.system; };
      checks.x86_64-linux = { canBuild = linux.activationPackage; };

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
      formatter.aarch64-linux = nixpkgs.legacyPackages.aarch64-linux.nixpkgs-fmt;
      formatter.aarch64-darwin = nixpkgs.legacyPackages.aarch64-darwin.nixpkgs-fmt;
    };
}
