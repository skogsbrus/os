{ config, pkgs, ... }:

{
  services.dbus.packages = with pkgs; [ gnome.dconf ];

  services.xserver = {
    # Enable the X11 windowing system.
    enable = true;

    # Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = true;

    displayManager.gdm.enable = true;

    # Use wayland for now, otherwise USB-C dock doesn't work :(
    displayManager.gdm.wayland = false;

    # Enable the GNOME Desktop Environment.
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

  environment.systemPackages = with pkgs; [ xorg.xkill ];
}
