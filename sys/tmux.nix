{ config
, pkgs
, lib
, ...
}:
let
  aw-watcher-tmux = pkgs.tmuxPlugins.mkTmuxPlugin {
    # TODO: contribute to nixpkgs
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

      # Restore stuff
      set -g @resurrect-capture-pane-contents 'on'
      set -g @resurrect-processes 'ssh psql "git log" '
    '';
    # TODO: There must be better way to do separate which hosts certain plugins
    # should be installed on. Add some 'role' attribute on hosts so I don't
    # have to reference them directly?
    # TODO: How to avoid listing plugins twice?
    plugins =
      if config.networking.hostName == "router" then [
        pkgs.tmuxPlugins.resurrect
      ] else [
        aw-watcher-tmux
        pkgs.tmuxPlugins.resurrect
      ];
  };

}
