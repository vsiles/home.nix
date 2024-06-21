{ config, pkgs, actualName, username, email, ... }:
let
  hs-nix = pkgs.writeShellScriptBin "hs-nix" (builtins.readFile ./hs-nix.sh);
in
{
  imports = [
    ./terminals
    ./editors
    ./programs
    ./shells
  ];

  config = {
    home.stateVersion = "23.05"; # TODO: 24.05

    fonts.fontconfig.enable = true;

    home.packages = with pkgs; [
      # Fonts & helpers
      (nerdfonts.override {
        fonts = [ "UbuntuMono" "JetBrainsMono" "NerdFontsSymbolsOnly" "ProggyClean" ];
      })
      bashInteractive # make sure we at least have modern bash
    ];

    home.sessionVariables = {
      EDITOR = "nvim";
    };
  };
}
