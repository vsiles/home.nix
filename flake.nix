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
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = false;

              home-manager.users.${username} = {
                imports = [ ./home.nix ];
              };

              nixpkgs = {
                overlays = [];
                config.allowUnfree = allowUnfree;
              };

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

      checks.aarch64-darwin = { canBuild = mac.system; };
      checks.x86_64-linux = { canBuild = linux.activationPackage; };

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
      formatter.aarch64-linux = nixpkgs.legacyPackages.aarch64-linux.nixpkgs-fmt;
      formatter.aarch64-darwin = nixpkgs.legacyPackages.aarch64-darwin.nixpkgs-fmt;
    };
}
