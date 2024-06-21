{
  description = "My personal Nix configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs, ... }:
  {
    homeConfigurations = {
      home = {
        imports = [ ./home.nix ];
      };
    };
  };
}
