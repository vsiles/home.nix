{ config, pkgs, lib, ... }:
{
  programs.eza = {
    enable = true;
    enableFishIntegration = true;
    git = true;
    icons = true;
  };
}