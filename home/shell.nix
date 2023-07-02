{ config
, lib
, pkgs
, unstable
, ...
}:
let
  cfg = config.skogsbrus.shell;
  inherit (lib) types mkIf mkOption mkEnableOption;

  zsh = {
    programs.zsh = mkIf cfg.zsh {
      enable = true;
      autocd = true;
      shellAliases = {
        gs = "git status";
        gd = "git diff";
        gdc = "git diff --cached";
        gac = "git commit --amend";
        gap = "git add --patch";
        gpfw = "CMD= \"git push origin $(git rev-parse --abbrev-ref HEAD) --force-with-lease\" ; echo \"$CMD\" ; echo \"Confirm [y/n]\" && read && if [[ $REPLY =~ ^[Yy]$ ]]; then eval $CMD ; else echo \"Aborted.\" ; fi";
        gp = "git push origin $(git rev-parse --abbrev-ref HEAD)";
      };
      enableSyntaxHighlighting = true;
      initExtra = ''
        # direnv hook
        eval "$(direnv hook zsh)"

        # enable fzf
        if command -v fzf-share &> /dev/null; then
          source "$(fzf-share)/key-bindings.zsh"
          source "$(fzf-share)/completion.zsh"
        fi

        # enable atuin
        #eval "$(atuin init zsh)"

        # Load version control info
        autoload -Uz vcs_info
        precmd() { vcs_info }

        # Format version control info
        zstyle ':vcs_info:git:*' formats '(%b)'

        # Show git branch in prompt
        setopt PROMPT_SUBST
        PROMPT='%n@%m%f %F{yellow}$vcs_info_msg_0_ %F{green}%~%f %F{reset}'

        # Edit line in vim
        autoload edit-command-line; zle -N edit-command-line
        bindkey '^e' edit-command-line

        # Add timestamps in history
        HIST_STAMPS="dd.mm.yyyy"

        export EDITOR=vim

        # Disable shared history
        unsetopt share_history
      '';
    };
  };

  tmux = {
    programs.tmux = mkIf cfg.tmux {
      enable = true;
      baseIndex = 1;
      escapeTime = 0;
      historyLimit = 5000;
      extraConfig = ''
        # intuitive split bindings
        bind | split-window -h
        bind - split-window -v

        # theme
        set -g status-fg ${cfg.tmuxFgColor}
        set -g status-bg ${cfg.tmuxBgColor}

        # enables pane resizing and text selection with mouse
        set -g mouse on

        # set leader to Alt-a
        unbind C-b
        set-option -g prefix M-a

        # for fast & predictable navigation
        set-option -g repeat-time 0

        # window names
        set-option -g status-interval 5
        set-option -g automatic-rename on
        set-option -g automatic-rename-format '#{b:pane_current_path}'

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
    };
  };

  atuin = {
    programs.atuin = mkIf cfg.atuin {
      enable = true;
      enableZshIntegration = false;
      settings = {
        dialect = "uk"; # don't use American date formats
        update_check = false;
        filter_mode = "host";
        filter_mode_shell_up_key_binding = "session";
      };
    };
  };

  fzf = {
    programs.fzf = {
      enable = true;
    };
  };

  direnv = {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
in
{

  options.skogsbrus.shell = {
    zsh = mkEnableOption "Enable ZSH shell";
    tmux = mkEnableOption "Enable Tmux config";
    atuin = mkEnableOption "Enable atuin";

    tmuxBgColor = mkOption {
      type = types.str;
      example = "red";
      default = "green";
      description = "Background color of the bottom bar";
    };

    tmuxFgColor = mkOption {
      type = types.str;
      example = "white";
      default = "white";
      description = "Foreground color of the bottom bar";
    };

  };

  config = lib.foldl lib.recursiveUpdate { } [
    atuin
    direnv
    fzf
    tmux
    zsh
  ];
}
