{ config, pkgs, ... }:

{
  services.xserver = {
    # Enable the X11 windowing system.
    enable = true;

    # Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = true;

    # Enable the GNOME 3 Desktop Environment.
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;

    # Add custom keyboard layout
    extraLayouts.us-swedish = {
      description = "US layout with alt-gr Swedish";
      languages = [ "eng" ];
      symbolsFile = ./keyboard/symbols/us-swedish;
    };

    # Configure keymap in X11
    layout = "us-swedish";
    xkbOptions = "caps:escape";

  };
}
