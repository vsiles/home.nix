{ config, pkgs, lib, ... }:
# let
#   tmux-status-theme = pkgs.tmuxPlugins.mkTmuxPlugin {
#     pluginName = "minimal";
#     version = "unstable-2024-02-25";
#     src = pkgs.fetchFromGitHub {
#       owner = "niksingh710";
#       repo = "minimal-tmux-status";
#       rev = "5183698f30c521fdf890d287e3ba2f81ea4e0d1c";
#       sha256 = "sha256-BrlMV4w1AsjLTjwKQXuOGRPy8QFsS4JtFtGFRUluQ50=";
#     };
#   };
{
  programs.tmux = {
    enable = true;
    sensibleOnTop = false;
    shell = "${pkgs.fish}/bin/fish";
    # terminal = "tmux-256color";
    terminal = "alacritty";
    prefix = "C-b";
    keyMode = "vi";
    mouse = true;
    historyLimit = 10000;
    escapeTime = 100;
    # baseIndex = 1;
    # disableConfirmationPrompt = true;
    plugins = with pkgs; [
      #   {
      #     plugin = tmux-status-theme;
      #     extraConfig = ''
      #       set -g @minimal-tmux-bg "#7daea3"
      #       set -g @minimal-tmux-indicator-str "  [tmux]  "
      #       # false will make it visible for the current tab only
      #       set -g @minimal-tmux-show-expanded-icons-for-all-tabs true
      #       # To add or remove extra text in status bar
      #       set -g @minimal-tmux-status-right-extra ""
      #       set -g @minimal-tmux-status-left-extra ""
      #     '';
      #   }
      { plugin = tmuxPlugins.urlview; }
      { plugin = tmuxPlugins.fpp; }
    ];
    extraConfig = ''
      # set -ag terminal-overrides ",xterm-256color:Tc"
      set -sg terminal-overrides ",*:RGB"

      set -g detach-on-destroy off

      set -g update-environment 'DISPLAY SSH_ASKPASS SSH_AGENT_PID SSH_CONNECTION WINDOWID XAUTHORITY TERM PATH'

      setw -g xterm-keys

      bind-key j select-pane -D
      bind-key k select-pane -U
      bind-key h select-pane -L
      bind-key l select-pane -R
      
      bind-key C-x split-window -h -c "#{pane_current_path}"
      bind-key C-v split-window -v -c "#{pane_current_path}"
      # unbind '"'
      # unbind %
      
      bind-key \   select-window -l
      
      bind-key + resize-pane -U 20
      bind-key - resize-pane -D 20
      bind-key > resize-pane -R 20
      bind-key < resize-pane -L 20
      bind-key z resize-pane -Z
      
      set -g set-clipboard on
      set -g focus-events on

      # https://www.hamvocke.com/blog/a-guide-to-customizing-your-tmux-conf/
      set-option -g visual-activity off
      set-option -g visual-bell off
      set-option -g visual-silence off
      set-window-option -g monitor-activity off
      set-option -g bell-action none

      # modes
      setw -g clock-mode-colour colour5
      setw -g mode-style fg=colour1,bg=colour18,bold

      # panes
      set -g pane-border-style fg=colour19,bg=colour0
      set -g pane-active-border-style fg=colour9,bg=colour0

      # statusbar
      set -g status-position bottom
      set -g status-justify left
      set -g status-style fg=colour137,bg=colour18
      set -g status-left ""
      set -g status-right "#[fg=colour233,bg=colour19,bold] %d/%m [fg=colour233,bg=colour8,bold] %H:%M:%S "
      set -g status-right-length 50
      set -g status-left-length 20

      setw -g window-status-current-style fg=colour1,bg=colour19,bold
      setw -g window-status-current-format " #I#[fg=colour249]:#[fg=colour255]#W#[fg=colour249]#F "

      setw -g window-status-style fg=colour9,bg=colour18,none
      setw -g window-status-format " #I#[fg=colour237]:#[fg=colour250]#W#[fg=colour244]#F "

      setw -g window-status-bell-style fg=colour255,bg=colour1,bold

      # messages
      # set -g message-attr bold
      # set -g message-fg colour232
      # set -g message-bg colour16

      # image preview from yazi
      set -g allow-passthrough on
      set -ga update-environment TERM
      set -ga update-environment TERM_PROGRAM

      # TODO: Below here, options from Omar config I should learn about
      # set-option -g renumber-windows on

      # multiline status bar for padding
      # set -Fg "status-format[1]" "#{status-format[0]}"
      # set -g "status-format[0]" ""
      # set -g status 2

      # Create a new window in the current directory
      # bind c new-window -c "#{pane_current_path}"

      # Renumber all windows
      # bind R move-window -r

      # Easier reload of config
      # bind r source-file ~/.config/tmux/tmux.conf
    '';
  };
}

