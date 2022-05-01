{ ... }:
{
  services.tlp = {
    enable = true;
    settings.START_CHARGE_THRESH_BAT0=75;
    settings.STOP_CHARGE_THRESH_BAT0=80;

    settings.CPU_SCALING_GOVERNOR_ON_AC="schedutil";
    settings.CPU_SCALING_GOVERNOR_ON_BAT="schedutil";

    settings.CPU_SCALING_MIN_FREQ_ON_AC=800000;
    settings.CPU_SCALING_MAX_FREQ_ON_AC=2300000;
    settings.CPU_SCALING_MIN_FREQ_ON_BAT=800000;
    settings.CPU_SCALING_MAX_FREQ_ON_BAT=2300000;

    # Enable audio power saving for Intel HDA, AC97 devices (timeout in secs).
    # A value of 0 disables, >=1 enables power saving (recommended: 1).
    # Default: 0 (AC), 1 (BAT)
    settings.SOUND_POWER_SAVE_ON_AC=0;
    settings.SOUND_POWER_SAVE_ON_BAT=1;

    # Runtime Power Management for PCI(e) bus devices: on=disable, auto=enable.
    # Default: on (AC), auto (BAT)
    settings.RUNTIME_PM_ON_AC="on";
    settings.RUNTIME_PM_ON_BAT="auto";

    # Battery feature drivers: 0=disable, 1=enable
    # Default: 1 (all)
    settings.NATACPI_ENABLE=1;
    settings.TPACPI_ENABLE=1;
    settings.TPSMAPI_ENABLE=1;
  };
}
