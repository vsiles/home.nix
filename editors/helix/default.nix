# Helix configuration
#
# <https://helix-editor.com/>
#
# I always use latest master so docs are at <https://docs.helix-editor.com/master/>.

{ config, lib, pkgs, home, ... }:
{
  programs.helix = {
    enable = true;
    defaultEditor = true;

    languages = import ./languages.nix { inherit config lib pkgs home; };
    settings = import ./config.nix { };
    themes.vsiles = import ./theme.nix { };
    ignores = [
      # VCS
      ".git"
      ".jj"

      # Direnv
      ".direnv"

      # Python
      ".mypy_cache"
      ".pytest_cache"
      ".ruff_cache"
      "__pycache__"
    ];
  };
}
