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
  cfg = config.skogsbrus.tmux;
  inherit (lib) mkOption types mkIf mkEnableOption;
in
{
  options.skogsbrus.tmux = {
    enable = mkEnableOption "tmux";

    bg_color = mkOption {
      type = types.str;
      example = "red";
      default = "green";
      description = "Background color of the bottom bar";
    };

    fg_color = mkOption {
      type = types.str;
      example = "white";
      default = "white";
      description = "Foreground color of the bottom bar";
    };

    aw_watcher = mkEnableOption "aw_watcher";
  };

  config = mkIf cfg.enable {
    programs.tmux = {
      enable = true;
      baseIndex = 1;
      escapeTime = 0;
      extraConfig = ''
        # intuitive split bindings
        bind | split-window -h
        bind - split-window -v

        # theme
        set -g status-fg ${cfg.fg_color}
        set -g status-bg ${cfg.bg_color}

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
        set -g @resurrect-processes 'watch ssh psql "git log" '
      '';

      plugins = [
        pkgs.tmuxPlugins.resurrect
      ] ++
        (if cfg.aw_watcher then [ aw-watcher-tmux ] else []);
    };
  };
}
