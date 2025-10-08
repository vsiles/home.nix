# Jujutsu configuration
#
# <https://github.com/martinvonz/jj>

{ config
, pkgs
, email
, actualName
, unstablePkgs
, ...
}:
let
  jj-config = builtins.readFile ./jujutsu.toml;
in
{
  home.sessionVariables.JJ_CONFIG = "${config.xdg.configHome}/jj/config.toml";
  home.packages = [ unstablePkgs.jujutsu ];

  # Using file to get access to custom path: <https://github.com/nix-community/home-manager/issues/5001>
  xdg.configFile."jj/config.toml".text = ''
    ${jj-config}

    # <https://martinvonz.github.io/jj/latest/config/#user-settings>
    [user]
    email = "${email}"
    name = "${actualName}"
  '';
}
