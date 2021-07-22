{ config, pkgs, ... }:

{
  services.xserver = {
    # Enable the X11 windowing system.
    enable = true;

    # Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = true;

    # Enable the GNOME Desktop Environment.
    displayManager.gdm.enable = true;
    desktopManager.gnome = {
      enable = true;
      extraGSettingsOverridePackages = with pkgs; [ gnome.gnome-settings-daemon ];

      # Keybindings / settings
      # Dumped with `dconf dump /org/gnome/settings-daemon/plugins/`
      extraGSettingsOverrides = ''
        [color]
        night-light-enabled=true
        night-light-temperature=uint32 3700

        [media-keys]
        custom-keybindings=['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/']

        [media-keys/custom-keybindings/custom0]
        binding='<Super>Return'
        command='gnome-terminal'
        name='Open terminal'
      '';
    };

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
