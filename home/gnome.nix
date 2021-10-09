{ pkgs, ... }:
{
  gtk = {
    enable = true;
    #font.name = "Victor Mono SemiBold 10";
    theme = {
      name = "Numix";
      package = pkgs.numix-gtk-theme;
      #package = pkgs.pop-gtk-theme;
    };
  };
}
