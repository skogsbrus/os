{ pkgs, ... }:
{
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTR{idVendor}=="4255", ATTR{idProduct}=="0012" MODE="0666"
    SUBSYSTEM=="usb", ATTR{idVendor}=="4255", ATTR{idProduct}=="0014" MODE="0666"
    SUBSYSTEM=="usb", ATTR{idVendor}=="4255", ATTR{idProduct}=="0001" MODE="0666"
    SUBSYSTEM=="usb", ATTR{idVendor}=="0403", ATTR{idProduct}=="6010" MODE="0666"
  '';

  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
  programs.dconf.enable = true;
  environment.systemPackages = with pkgs; [ virt-manager ];
}
