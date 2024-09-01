{ config, pkgs, name, email, ... }: {
  programs.pyenv = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
  };
}
