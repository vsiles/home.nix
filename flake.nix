{
  description = "vsiles' Nix configuration flake";

  inputs = {
    unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    { nixpkgs
    , unstable
    , home-manager
    , ...
    }:
    let
      system = "x86_64-linux";
      username = "vsiles";
      actualName = "Vincent Siles";
      email = "vincent.siles@ens-lyon.org";
      allowUnfree = true; # allow unfree packages to be installed

      specialArgs = {
        home = "/home/${username}";
        unstablePkgs = import unstable { inherit system; };
        inherit
          username
          actualName
          email
          ;
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
      homeConfigurations."vsiles" = linux;

      checks."$system" = {
        canBuild = linux.activationPackage;
      };

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
    };
}
