{ config, pkgs, actualName, username, email, ... }:
{
  imports = [
    ./terminals
    ./editors
    ./programs
    ./shells
  ];

  config = {
    home.stateVersion = "24.05";

    fonts.fontconfig.enable = true;

    home.packages = with pkgs; [
      # Fonts & helpers
      (nerdfonts.override {
        fonts = [ "UbuntuMono" "JetBrainsMono" "NerdFontsSymbolsOnly" "ProggyClean" ];
      })
      bashInteractive # make sure we at least have modern bash
    ];

    # XDG setup
    xdg.enable = true;
    xdg.configHome = "${config.home.homeDirectory}/.config";
    # Put all dirs in .local because I like having $HOME as clean as possible
    # xdg.cacheHome = "${config.home.homeDirectory}/.local/cache";
    # xdg.dataHome = "${config.home.homeDirectory}/.local/share";
    # xdg.stateHome = "${config.home.homeDirectory}/.local/state";


    home.sessionVariables = {
      # EDITOR = "hx"; # see helix.defaultEditor
      VISUAL = "hx";

      # Where the tempdirs are created, if at all respected. The other XDG env vars are created
      # by the `xdg.enable = true` earlier
      XDG_RUNTIME_DIR = "/var/tmp/$(id -u)";

      # Rust
      # TODO(vsiles) configure rustc / cargo that way
      # RUSTUP_HOME = "${config.xdg.dataHome}/rustup";
      # CARGO_HOME = "${config.xdg.dataHome}/cargo";
      RUSTUP_HOME = "${config.home.homeDirectory}/.rustup";
      CARGO_HOME = "${config.home.homeDirectory}/.cargo";
    };
  };
}
