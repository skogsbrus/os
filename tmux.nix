{ config, pkgs, lib, ... }:

{
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    escapeTime = 0;
    extraConfig = ''

      bind | split-window -h
      bind - split-window -w

      # theme
      set-option status-style fg=#ffa500,bg=black

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
