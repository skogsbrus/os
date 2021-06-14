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
      PROMPT='%F{208}%n@%m%f %F{226}%~%f '      
    '';
  };

}
