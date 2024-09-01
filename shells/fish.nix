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
      # TODO: add back ivakyb/fish_ssh_agent
    ];

    shellInit = ''
      # NIX
      # usually in /etc/<shell>rc but nix install didn't update fish, so I keep it here

      # bass . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

      # Lame fix: for some reason NIX_SSL_CERT_FILE is set before we reach this
      # so the "only run once" guard in the hm script prevents the right value to
      # be setup. Let's get rid of it
      # set -e __HM_SESS_VARS_SOURCED
      # bass . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"

      # helix and nvim wants that path to exist and be writable
      mkdir -p "$XDG_RUNTIME_DIR"
    '';

    interactiveShellInit = ''
      set -U fish_greeting

      # start ssh-agent
      # fish_ssh_agent

      set -x LC_ALL en_US.UTF-8
      set -x LANG en_US.UTF-8

      # fish_add_path $HOME/.cargo/bin
      # fish_add_path $HOME/.local/bin
      # fish_add_path /usr/local/bin # for code

      # eval (/opt/homebrew/bin/brew shellenv)

      # aws completion
      set -gx PATH $PATH ${pkgs.awscli2}/bin/aws_completer
      complete -c aws -a "(env AWS_PROFILE=default aws_completer)"

      # jujutsu completion
      jj util completion fish | source
    '';

    shellAliases = {
      ls = "eza --icons --group-directories-first --git";
    };

    functions = {
      rm = {
        body = "command rm -i $argv";
        description = "safe rm";
      };
      # TODO: install slap via nix
      python_stuff = {
        # source (pyenv init --path | psub)
        body = ''
          ${pkgs.pyenv}/bin/pyenv init - | source
          command -v slap &>/dev/null; and source (env SLAP_SHADOW=true slap venv -i fish | psub)
        '';
        description = "setup some python/slap state";
      };
      # aws alias
      aws-login = {
        body = "${pkgs.awscli2}/bin/aws sso login --sso-session helsing";
      };
      aws-dev = {
        body = "${pkgs.awscli2}/bin/aws eks update-kubeconfig --name spine-dev --region eu-west-1 --profile spine-dev";
      };
      aws-stage = {
        body = "${pkgs.awscli2}/bin/aws eks update-kubeconfig --name spine-stage --region eu-west-1 --profile spine-stage";
      };
      aws-prod = {
        body = "${pkgs.awscli2}/bin/aws eks update-kubeconfig --name spine-prod --region eu-west-1 --profile spine-prod";
      };
      # file explorer
      yy = {
        body = ''
          set tmp (mktemp -t "yazi-cwd.XXXXX")
          ${pkgs.yazi}/bin/yazi $argv --cwd-file="$tmp"
          if set cwd (cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
              cd -- "$cwd"
          end
          rm -f -- "$tmp"
        '';
      };
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
