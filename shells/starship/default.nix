{ config, pkgs, ... }: {
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    # TODO: read about enableTransience
    settings = pkgs.lib.importTOML ./config.toml;
  };
}
