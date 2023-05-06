{ config
, lib
, ...
}:
let
  cfg = config.skogsbrus.zsh;
  inherit (lib) mkIf mkEnableOption types;
in
{
  options.skogsbrus.zsh = {
    enable = mkEnableOption "zsh";
  };

  config = mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      histSize = 20000;
      promptInit = ''
        # direnv hook
        eval "$(direnv hook zsh)"

        # enable fzf
        if command -v fzf-share &> /dev/null; then
          source "$(fzf-share)/key-bindings.zsh"
          source "$(fzf-share)/completion.zsh"
        fi

        # enable atuin
        if command -v atuin &> /dev/null; then
          eval "$(atuin init zsh)"
        fi

        # Load version control info
        autoload -Uz vcs_info
        precmd() { vcs_info }

        # Format version control info
        zstyle ':vcs_info:git:*' formats '(%b)'

        # Show git branch in prompt
        setopt PROMPT_SUBST
        PROMPT='%n@%m%f %F{yellow}$vcs_info_msg_0_ %F{green}%~%f %F{reset}'

        alias gs="git status"
        alias gd="git diff"
        alias gdc="git diff --cached"
        alias gac="git commit --amend"
        alias gap="git add --patch"
        alias gpfw='CMD="git push origin $(git rev-parse --abbrev-ref HEAD) --force-with-lease" ; echo "$CMD" ; echo "Confirm [y/n]" && read && if [[ $REPLY =~ ^[Yy]$ ]]; then eval $CMD ; else echo "Aborted." ; fi'
        alias gp='git push origin $(git rev-parse --abbrev-ref HEAD)'

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
}
