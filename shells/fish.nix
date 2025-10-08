{ config, pkgs, ... }: {
  programs.fish = {
    enable = true;

    plugins = [
      {
        name = "bass";
        src = pkgs.fishPlugins.bass.src;
      }
      {
        name = "z";
        src = pkgs.fishPlugins.z.src;
      }
      {
        name = "fzf";
        src = pkgs.fishPlugins.fzf.src;
      }
    ];

    shellInit = ''
      # helix and nvim wants that path to exist and be writable
      mkdir -p "$XDG_RUNTIME_DIR"

      # Make sure it's there and not in $fish_user_paths otherwise it messes up with
      # nix develop
      fish_add_path --prepend --path "/nix/var/nix/profiles/default/bin"
      fish_add_path --prepend --path "$HOME/.nix-profile/bin"

      fish_add_path --prepend --path "/usr/local/bin"
      fish_add_path --prepend --path "$HOME/.local/bin"
      fish_add_path --prepend --path "$HOME/.cargo/bin"
      fish_add_path --prepend --path "/opt/homebrew/bin"
    '';

    interactiveShellInit = ''
      set -U fish_greeting

      set -x LC_ALL en_US.UTF-8
      set -x LANG en_US.UTF-8

      # aws completion
      complete -c aws -a "(env AWS_PROFILE=default ${pkgs.awscli2}/bin/aws_completer)"

      # jujutsu completion
      jj util completion fish | source

      # so that nix-shell stays in fish instead of bash
      # Note that the --info-right doesn't show because I'm using starship
      any-nix-shell fish --info-right | source
    '';

    shellAliases = {
      ls = "eza --icons --group-directories-first --git";
    };

    functions = {
      rm = {
        body = "command rm -i $argv";
        description = "safe rm";
      };
      # file explorer
      # TODO: check out yazi in home-manager. Seems like it provides this in its fish integration
      # yy = {
      #   body = ''
      #     set tmp (mktemp -t "yazi-cwd.XXXXX")
      #     ${pkgs.yazi}/bin/yazi $argv --cwd-file="$tmp"
      #     if set cwd (cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
      #         cd -- "$cwd"
      #     end
      #     rm -f -- "$tmp"
      #   '';
      # };
      helix-install = {
        body = ''
          set -q XDG_CACHE_HOME || set -U XDG_CACHE_HOME $HOME/.cache
          set -q XDG_CONFIG_HOME || set -U XDG_CONFIG_HOME $HOME/.config

          cd $XDG_CACHE_HOME

          git clone https://github.com/helix-editor/helix.git --single-branch --branch master helix-repo

          cd helix-repo

          cargo +stable install --locked --path helix-term
          set RUNTIME_DIR (pwd)/runtime
          pushd $XDG_CONFIG_HOME
          ln -s $RUNTIME_DIR helix
          popd

          # Will work in `~/.config/helix/runtime`, see <https://github.com/helix-editor/helix/issues/9565>
          hx --grammar fetch
          hx --grammar build
        '';
      };
    };
  };
}
# Old theme config. Now using starship
# # set -l red    e2a690
# set -l bright_green aaff00
# set -l cadmium_green 097969
# set fish_color_user $cadmium_green
