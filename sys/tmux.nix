{ config
, pkgs
, lib
, ...
}:
let
  aw-watcher-tmux = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "aw-watcher-tmux";
    version = "0.1";
    src = pkgs.fetchFromGitHub {
      owner = "skogsbrus";
      repo = "aw-watcher-tmux";
      rev = "797f279729c5606f6246b2ce60aa84b603a21c15";
      sha256 = "KLGknVxA65AqsRfXEbo2mWaXlFc7BdFapoSbZOiAotI=";
    };
  };
in
{
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    escapeTime = 0;
    extraConfig = ''

      # intuitive split bindings
      bind | split-window -h
      bind - split-window -v

      # theme
      set -g status-fg white
      set -g status-bg ${
        if config.networking.hostName == "workstation" then "blue"
        else if config.networking.hostName == "router" then "red"
        else "green"
      }

      # enables pane resizing and text selection with mouse
      set -g mouse on

      # set leader to Alt-a
      unbind C-b
      set-option -g prefix M-a

      # for fast & predictable navigation
      set-option -g repeat-time 0

      # vim-like navigation
      setw -g mode-keys vi
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      bind -T copy-mode-vi v send-keys -X begin-selection
      bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "xclip -in -selection clipboard"

      # broadcast to all panes
      bind C-a setw synchronize-panes
    '';
    plugins = with pkgs.tmuxPlugins; [ aw-watcher-tmux ];
  };

}
