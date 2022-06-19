{ config, lib, pkgs, unstable, home-manager, ... }:
{
 programs.kitty = {
   enable = true;
   #package = with unstable.legacyPackages.${pkgs.system}; kitty;
   theme = "Gruvbox Material Dark Hard";

    #extraConfig = ''
    #  include ${pkgs.kitty-themes}/${
    #    (builtins.head (builtins.filter (x: x.name == "Gruvbox Material Dark Hard") (builtins.fromJSON
    #      (builtins.readFile "${pkgs.kitty-themes}/themes.json")))).file
    #  }
    #'';
 };
}
