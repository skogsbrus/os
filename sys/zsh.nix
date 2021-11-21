{ config, lib, pkgs, ... }:
{
  programs.zsh = {
  
    enable = true;
    #shellInit = ''
    #'';
    histSize = 20000;
    promptInit = ''
      # direnv hook
      eval "$(direnv hook zsh)"

      # Load version control info
      autoload -Uz vcs_info
      precmd() { vcs_info }

      # Format version control info
      zstyle ':vcs_info:git:*' formats '(%b)'

      # Show git branch in prompt
      setopt PROMPT_SUBST
      PROMPT='%n@%m%f %F{yellow}$vcs_info_msg_0_ %F{green}%~%f %F{reset}'

      autoload predict-on
      predict-on

      alias gs="git status"
      alias gd="git diff"
      alias gdc="git diff --cached"

      # Add timestamps in history
      HIST_STAMPS="dd.mm.yyyy"

      # enable fzf
      if command -v fzf-share >/dev/null; then
        source "$(fzf-share)/key-bindings.zsh"
        source "$(fzf-share)/completion.zsh"
      fi

      export EDITOR=vim

      # Disable shared history
      unsetopt share_history
    '';
  };
}
