{ config, pkgs, lib, ... }:
{
  programs.wezterm = {
    enable = true;
    # package = nixGL pkgs.wezterm;
    # enableZshIntegration = true;
    extraConfig = builtins.readFile ./config.lua;
  };
}
