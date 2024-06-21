{
  description = "My personal Nix configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      {
        homeConfigurations = {
          vsiles-home = {
            inherit system;
            imports = [ ./home.nix ];
          };
        };
      }
    );
}
