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

      # rudimentary theme
      PROMPT="%F{208}%n@%m%f %F{226}%~%f "
      alias gs="git status"
      alias gd="git diff"
      alias gdc="git diff --cached"
      HIST_STAMPS="dd.mm.yyyy"

      # enable fzf
      if command -v fzf-share >/dev/null; then
        source "$(fzf-share)/key-bindings.zsh"
        source "$(fzf-share)/completion.zsh"
      fi

      export EDITOR=vim
    '';
  };
}
