{ config, pkgs, ... }: {
  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      log = { enabled = false; };
      manager = {
        show_hidden = true;
        show_symlink = true;
        sort_by = "alphabetical";
        sort_dir_first = true;
        # sort_reverse = true;
      };
      opener = {
        open = [{
          # TODO: use xdg-open on linux based system
          run = ''
            open "$@"
          '';
          desc = "Open";
          orphan = true;
        }];
      };
    };
    theme = { };
  };

  home.packages = with pkgs;
    [
      # image display in terminal
      ueberzugpp
    ];
}

