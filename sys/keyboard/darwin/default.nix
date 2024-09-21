{
  config, lib, ...
}
:
{
  options = { };

  config = {
    system.keyboard.enableKeyMapping = true;
    system.keyboard.remapCapsLockToEscape = true;
    system.activationScripts.extraActivation.text = ''
      echo "setting up keyboard layout ..." >&2
      cp /Users/johanan/code/os/sys/keyboard/darwin/US-SE.{icns,keylayout} "/Library/Keyboard Layouts"
      touch "/Library/Keyboard Layouts"
    '';
  };
}
