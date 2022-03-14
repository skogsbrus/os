{ config, pkgs, ... }:

{
  services.xserver = {
    # Enable the X11 windowing system.
    enable = true;

    # Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = true;

    desktopManager.plasma5.enable = true;
    displayManager.defaultSession = "plasmawayland";

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
