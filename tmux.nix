{ config, pkgs, lib, ... }:

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
      set-option status-style fg=black,bg=white

      # enables pane resizing and text selection with mouse
      set -g mouse on

      # set leader to Alt-a
      unbind C-b
      set-option -g prefix M-a

      # for fast & predictable navigation
      set-option repeat-time 0

      # vim-like navigation
      setw -g mode-keys vi
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R
    '';
  };
}
