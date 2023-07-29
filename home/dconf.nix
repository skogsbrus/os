# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{ lib, ... }:

with lib.hm.gvariant;

{
  dconf.settings = {
    "apps/seahorse/listing" = {
      keyrings-selected = [ "secret-service:///org/freedesktop/secrets/collection/awsvault" ];
    };

    "apps/seahorse/windows/key-manager" = {
      height = 476;
      width = 1216;
    };

    "com/uploadedlobster/peek" = {
      persist-window-geometry = mkTuple [ 1959 117 ];
      recording-output-format = "mp4";
    };

    "org/gnome/Console" = {
      font-scale = 1.2;
      last-window-size = mkTuple [ 972 673 ];
      theme = "night";
    };

    "org/gnome/Totem" = {
      active-plugins = [ "variable-rate" "screenshot" "movie-properties" "open-directory" "apple-trailers" "recent" "rotation" "autoload-subtitles" "save-file" "vimeo" "media-player-keys" "skipto" "screensaver" ];
      subtitle-encoding = "UTF-8";
    };

    "org/gnome/Weather" = {
      locations = "[<(uint32 2, <('Lund, Sweden', '', false, [(0.97219952452660785, 0.23026032653919404)], [(0.97040306410884714, 0.22689280275926285)])>)>]";
    };

    "org/gnome/baobab/ui" = {
      is-maximized = false;
      window-size = mkTuple [ 1217 600 ];
      window-state = 87168;
    };

    "org/gnome/calendar" = {
      active-view = "month";
      window-maximized = true;
      window-position = mkTuple [ 0 32 ];
      window-size = mkTuple [ 1920 1048 ];
    };

    "org/gnome/cheese" = {
      brightness = -0.146341;
      burst-delay = 1000;
      camera = "USB 2.0 PC Camera: PC Camera";
      contrast = 1.0;
      hue = 0.0;
      photo-x-resolution = 640;
      photo-y-resolution = 480;
      saturation = 0.943089;
      video-x-resolution = 640;
      video-y-resolution = 480;
    };

    "org/gnome/clocks" = {
      world-clocks = "[{'location': <(uint32 2, <('San Francisco', 'KOAK', true, [(0.65832848982162007, -2.133408063190589)], [(0.659296885757089, -2.1366218601153339)])>)>}, {'location': <(uint32 2, <('New York', 'KNYC', true, [(0.71180344078725644, -1.2909618758762367)], [(0.71059804659265924, -1.2916478949920254)])>)>}]";
    };

    "org/gnome/clocks/state/window" = {
      maximized = false;
      panel-id = "world";
      size = mkTuple [ 870 690 ];
      state = 87168;
    };

    "org/gnome/control-center" = {
      last-panel = "background";
      window-state = mkTuple [ 980 640 ];
    };

    "org/gnome/desktop/a11y/interface" = {
      high-contrast = false;
    };

    "org/gnome/desktop/app-folders" = {
      folder-children = [ "Utilities" "YaST" ];
    };

    "org/gnome/desktop/app-folders/folders/Utilities" = {
      apps = [ "gnome-abrt.desktop" "gnome-system-log.desktop" "nm-connection-editor.desktop" "org.gnome.baobab.desktop" "org.gnome.Connections.desktop" "org.gnome.DejaDup.desktop" "org.gnome.Dictionary.desktop" "org.gnome.DiskUtility.desktop" "org.gnome.eog.desktop" "org.gnome.Evince.desktop" "org.gnome.FileRoller.desktop" "org.gnome.fonts.desktop" "org.gnome.seahorse.Application.desktop" "org.gnome.tweaks.desktop" "org.gnome.Usage.desktop" "vinagre.desktop" ];
      categories = [ "X-GNOME-Utilities" ];
      name = "X-GNOME-Utilities.directory";
      translate = true;
    };

    "org/gnome/desktop/app-folders/folders/YaST" = {
      categories = [ "X-SuSE-YaST" ];
      name = "suse-yast.directory";
      translate = true;
    };

    "org/gnome/desktop/background" = {
      color-shading-type = "solid";
      picture-options = "zoom";
      picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/adwaita-l.webp";
      picture-uri-dark = "file:///run/current-system/sw/share/backgrounds/gnome/adwaita-d.webp";
      primary-color = "#3071AE";
      secondary-color = "#000000";
    };

    "org/gnome/desktop/calendar" = {
      show-weekdate = true;
    };

    "org/gnome/desktop/input-sources" = {
      per-window = false;
      sources = [ (mkTuple [ "xkb" "us-swedish" ]) ];
      xkb-options = [ "caps:escape" "lv3:ralt_switch" ];
    };

    "org/gnome/desktop/interface" = {
      clock-show-date = true;
      clock-show-seconds = false;
      clock-show-weekday = false;
      color-scheme = "prefer-dark";
      enable-hot-corners = false;
      font-antialiasing = "grayscale";
      font-hinting = "slight";
      font-name = "Source Sans Variable 10";
      gtk-theme = "Numix";
      show-battery-percentage = true;
      text-scaling-factor = 1.25;
      toolkit-accessibility = false;
    };

    "org/gnome/desktop/notifications" = {
      application-children = [ "gnome-power-panel" "gnome-network-panel" "org-gnome-fileroller" "spotify" "element-desktop" "org-gnome-baobab" "slack" "org-gnome-terminal" "chromium-browser" "org-gnome-nautilus" "code" "com-uploadedlobster-peek" ];
      show-banners = true;
    };

    "org/gnome/desktop/notifications/application/chromium-browser" = {
      application-id = "chromium-browser.desktop";
    };

    "org/gnome/desktop/notifications/application/code" = {
      application-id = "code.desktop";
    };

    "org/gnome/desktop/notifications/application/element-desktop" = {
      application-id = "element-desktop.desktop";
    };

    "org/gnome/desktop/notifications/application/firefox" = {
      application-id = "firefox.desktop";
    };

    "org/gnome/desktop/notifications/application/gimp" = {
      application-id = "gimp.desktop";
    };

    "org/gnome/desktop/notifications/application/gnome-control-center" = {
      application-id = "gnome-control-center.desktop";
    };

    "org/gnome/desktop/notifications/application/gnome-network-panel" = {
      application-id = "gnome-network-panel.desktop";
    };

    "org/gnome/desktop/notifications/application/gnome-power-panel" = {
      application-id = "gnome-power-panel.desktop";
    };

    "org/gnome/desktop/notifications/application/org-gnome-baobab" = {
      application-id = "org.gnome.baobab.desktop";
    };

    "org/gnome/desktop/notifications/application/org-gnome-calendar" = {
      application-id = "org.gnome.Calendar.desktop";
    };

    "org/gnome/desktop/notifications/application/org-gnome-console" = {
      application-id = "org.gnome.Console.desktop";
    };

    "org/gnome/desktop/notifications/application/org-gnome-eog" = {
      application-id = "org.gnome.eog.desktop";
    };

    "org/gnome/desktop/notifications/application/org-gnome-epiphany" = {
      application-id = "org.gnome.Epiphany.desktop";
    };

    "org/gnome/desktop/notifications/application/org-gnome-evince" = {
      application-id = "org.gnome.Evince.desktop";
    };

    "org/gnome/desktop/notifications/application/org-gnome-extensions" = {
      application-id = "org.gnome.Extensions.desktop";
    };

    "org/gnome/desktop/notifications/application/org-gnome-fileroller" = {
      application-id = "org.gnome.FileRoller.desktop";
    };

    "org/gnome/desktop/notifications/application/org-gnome-nautilus" = {
      application-id = "org.gnome.Nautilus.desktop";
    };

    "org/gnome/desktop/notifications/application/org-gnome-pomodoro" = {
      application-id = "org.gnome.Pomodoro.desktop";
    };

    "org/gnome/desktop/notifications/application/org-gnome-screenshot" = {
      application-id = "org.gnome.Screenshot.desktop";
    };

    "org/gnome/desktop/notifications/application/org-gnome-settings" = {
      application-id = "org.gnome.Settings.desktop";
    };

    "org/gnome/desktop/notifications/application/org-gnome-terminal" = {
      application-id = "org.gnome.Terminal.desktop";
    };

    "org/gnome/desktop/notifications/application/org-gnome-totem" = {
      application-id = "org.gnome.Totem.desktop";
    };

    "org/gnome/desktop/notifications/application/slack" = {
      application-id = "slack.desktop";
    };

    "org/gnome/desktop/notifications/application/spotify" = {
      application-id = "spotify.desktop";
    };

    "org/gnome/desktop/notifications/application/steam" = {
      application-id = "steam.desktop";
    };

    "org/gnome/desktop/notifications/application/virt-manager" = {
      application-id = "virt-manager.desktop";
    };

    "org/gnome/desktop/notifications/application/vlc" = {
      application-id = "vlc.desktop";
    };

    "org/gnome/desktop/notifications/application/wine-programs-remarkable-remarkable" = {
      application-id = "wine-Programs-reMarkable-reMarkable.desktop";
    };

    "org/gnome/desktop/notifications/application/writer" = {
      application-id = "writer.desktop";
    };

    "org/gnome/desktop/peripherals/keyboard" = {
      numlock-state = true;
    };

    "org/gnome/desktop/peripherals/mouse" = {
      natural-scroll = false;
      speed = 0.452174;
    };

    "org/gnome/desktop/peripherals/touchpad" = {
      speed = 0.843416;
      tap-to-click = true;
      two-finger-scrolling-enabled = true;
    };

    "org/gnome/desktop/privacy" = {
      disable-microphone = false;
    };

    "org/gnome/desktop/screensaver" = {
      color-shading-type = "solid";
      lock-enabled = false;
      picture-options = "zoom";
      picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/adwaita-l.webp";
      primary-color = "#3071AE";
      secondary-color = "#000000";
    };

    "org/gnome/desktop/search-providers" = {
      sort-order = [ "org.gnome.Contacts.desktop" "org.gnome.Documents.desktop" "org.gnome.Nautilus.desktop" ];
    };

    "org/gnome/desktop/session" = {
      idle-delay = mkUint32 0;
    };

    "org/gnome/desktop/wm/keybindings" = {
      close = [ "<Super>q" ];
      maximize = [];
      switch-input-source = [];
      switch-input-source-backward = [];
      toggle-maximized = [ "<Super>f" ];
    };

    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,maximize,close";
      focus-mode = "click";
      num-workspaces = 2;
    };

    "org/gnome/eog/ui" = {
      sidebar = true;
    };

    "org/gnome/eog/view" = {
      background-color = "rgb(0,0,0)";
      use-background-color = true;
    };

    "org/gnome/epiphany" = {
      ask-for-default = false;
    };

    "org/gnome/epiphany/state" = {
      is-maximized = true;
      window-position = mkTuple [ (-1) (-1) ];
      window-size = mkTuple [ 1024 768 ];
    };

    "org/gnome/evince" = {
      document-directory = "@ms 'file:///home/johanan/Sync/pdfs'";
    };

    "org/gnome/evince/default" = {
      window-ratio = mkTuple [ 2.889416 1.672428 ];
    };

    "org/gnome/evolution-data-server" = {
      migrated = true;
      network-monitor-gio-name = "";
    };

    "org/gnome/file-roller/dialogs/extract" = {
      recreate-folders = true;
      skip-newer = false;
    };

    "org/gnome/file-roller/listing" = {
      list-mode = "as-folder";
      name-column-width = 250;
      show-path = false;
      sort-method = "name";
      sort-type = "ascending";
    };

    "org/gnome/file-roller/ui" = {
      sidebar-width = 200;
      window-height = 480;
      window-width = 600;
    };

    "org/gnome/gedit/plugins" = {
      active-plugins = [ "sort" "docinfo" "spell" "filebrowser" "modelines" ];
    };

    "org/gnome/gedit/plugins/filebrowser" = {
      root = "file:///";
      tree-view = true;
      virtual-root = "file:///home/johanan/tmp/webex";
    };

    "org/gnome/gedit/preferences/ui" = {
      show-tabs-mode = "auto";
    };

    "org/gnome/gedit/state/file-chooser" = {
      open-recent = true;
    };

    "org/gnome/gedit/state/window" = {
      bottom-panel-size = 140;
      side-panel-active-page = "GeditWindowDocumentsPanel";
      side-panel-size = 200;
      size = mkTuple [ 900 700 ];
      state = 87168;
    };

    "org/gnome/gnome-screenshot" = {
      delay = 0;
      include-pointer = false;
      last-save-directory = "file:///home/johanan/Pictures";
    };

    "org/gnome/gnome-system-monitor" = {
      current-tab = "resources";
      maximized = false;
      network-total-in-bits = false;
      show-dependencies = false;
      show-whose-processes = "user";
      window-state = mkTuple [ 700 482 ];
    };

    "org/gnome/gnome-system-monitor/disktreenew" = {
      col-6-visible = true;
      col-6-width = 0;
    };

    "org/gnome/maps" = {
      last-viewed-location = [ 55.392031 13.581333 ];
      map-type = "MapsStreetSource";
      night-mode = false;
      transportation-type = "pedestrian";
      window-maximized = false;
      window-position = [ 26 23 ];
      window-size = [ 768 598 ];
      zoom-level = 15;
    };

    "org/gnome/meld/window-state" = {
      height = 351;
      is-maximized = false;
      width = 977;
    };

    "org/gnome/mutter" = {
      attach-modal-dialogs = true;
      dynamic-workspaces = true;
      edge-tiling = true;
      focus-change-on-pointer-rest = true;
      workspaces-only-on-primary = true;
    };

    "org/gnome/mutter/keybindings" = {
      toggle-tiled-left = [ "<Super>Left" ];
      toggle-tiled-right = [ "<Super>Right" ];
    };

    "org/gnome/mutter/wayland/keybindings" = {
      restore-shortcuts = [ "" ];
    };

    "org/gnome/nautilus/compression" = {
      default-compression-format = "zip";
    };

    "org/gnome/nautilus/preferences" = {
      default-folder-viewer = "list-view";
      migrated-gtk-settings = true;
      search-filter-time-type = "last_modified";
      search-view = "list-view";
    };

    "org/gnome/nautilus/window-state" = {
      initial-size = mkTuple [ 864 524 ];
      maximized = false;
      sidebar-width = 179;
    };

    "org/gnome/nm-applet/eap/10a0cf51-b7b6-4c8d-9d3d-2334fdcea9a8" = {
      ignore-ca-cert = false;
      ignore-phase2-ca-cert = false;
    };

    "org/gnome/nm-applet/eap/150aee1a-27c5-43ed-97ed-0023b84040d5" = {
      ignore-ca-cert = false;
      ignore-phase2-ca-cert = false;
    };

    "org/gnome/nm-applet/eap/16a01fb5-3297-4cf4-9c7c-e8971b976158" = {
      ignore-ca-cert = false;
      ignore-phase2-ca-cert = false;
    };

    "org/gnome/nm-applet/eap/242592dd-d630-46aa-bdfd-21233ad4506e" = {
      ignore-ca-cert = false;
      ignore-phase2-ca-cert = false;
    };

    "org/gnome/nm-applet/eap/30487139-8059-4abe-b25f-8215b25231ab" = {
      ignore-ca-cert = false;
      ignore-phase2-ca-cert = false;
    };

    "org/gnome/nm-applet/eap/43a4f86c-f78a-3c57-9125-b50958cee1d7" = {
      ignore-ca-cert = false;
      ignore-phase2-ca-cert = false;
    };

    "org/gnome/nm-applet/eap/51c85e26-d6f3-326b-ba68-d81f54b00501" = {
      ignore-ca-cert = false;
      ignore-phase2-ca-cert = false;
    };

    "org/gnome/nm-applet/eap/6522adda-3f7e-3afc-b72a-f0df12e8e509" = {
      ignore-ca-cert = false;
      ignore-phase2-ca-cert = false;
    };

    "org/gnome/nm-applet/eap/6d5388ba-00c5-49db-b548-0462c816f23b" = {
      ignore-ca-cert = false;
      ignore-phase2-ca-cert = false;
    };

    "org/gnome/nm-applet/eap/704cf396-6e0a-477d-ade8-9a7bd75f6b10" = {
      ignore-ca-cert = false;
      ignore-phase2-ca-cert = false;
    };

    "org/gnome/nm-applet/eap/73124c4d-aaa4-474d-bf86-b7bb9d9ebe0f" = {
      ignore-ca-cert = false;
      ignore-phase2-ca-cert = false;
    };

    "org/gnome/nm-applet/eap/7ed7d4d1-9a95-3193-935a-13ddbbf9eb35" = {
      ignore-ca-cert = false;
      ignore-phase2-ca-cert = false;
    };

    "org/gnome/nm-applet/eap/7f453819-e859-47b2-b01f-4fabaa8c76d5" = {
      ignore-ca-cert = true;
      ignore-phase2-ca-cert = false;
    };

    "org/gnome/nm-applet/eap/91c38c48-f4b2-3c4b-bc83-785b06e044bd" = {
      ignore-ca-cert = false;
      ignore-phase2-ca-cert = false;
    };

    "org/gnome/nm-applet/eap/9608d425-07c1-31ab-9afe-e2a90d0204ef" = {
      ignore-ca-cert = false;
      ignore-phase2-ca-cert = false;
    };

    "org/gnome/nm-applet/eap/9dcc8a2b-48b7-4644-a914-039ad6582627" = {
      ignore-ca-cert = false;
      ignore-phase2-ca-cert = false;
    };

    "org/gnome/nm-applet/eap/b3998ac4-1236-46cf-bb5b-0bf2493b5b50" = {
      ignore-ca-cert = false;
      ignore-phase2-ca-cert = false;
    };

    "org/gnome/nm-applet/eap/bd3516bc-b218-4699-81d1-cb6f7337bb18" = {
      ignore-ca-cert = false;
      ignore-phase2-ca-cert = false;
    };

    "org/gnome/nm-applet/eap/c21e0c8e-95e4-4267-876c-fde71d0d980c" = {
      ignore-ca-cert = false;
      ignore-phase2-ca-cert = false;
    };

    "org/gnome/nm-applet/eap/cc6ec38f-9873-3356-9804-4df6840b22cd" = {
      ignore-ca-cert = false;
      ignore-phase2-ca-cert = false;
    };

    "org/gnome/nm-applet/eap/e0edf65b-a3cd-4588-9d3a-1f94e661f113" = {
      ignore-ca-cert = false;
      ignore-phase2-ca-cert = false;
    };

    "org/gnome/nm-applet/eap/ed8053f0-894d-4b28-85a9-6fe9b53de5a9" = {
      ignore-ca-cert = false;
      ignore-phase2-ca-cert = false;
    };

    "org/gnome/nm-applet/eap/f68eb099-8d8f-3bef-b210-0d34a8da0755" = {
      ignore-ca-cert = false;
      ignore-phase2-ca-cert = false;
    };

    "org/gnome/pomodoro/plugins/gnome" = {
      hide-system-notifications = false;
    };

    "org/gnome/pomodoro/state" = {
      timer-date = "2021-09-20T11:32:33+0000";
      timer-elapsed = 0.0;
      timer-paused = false;
      timer-score = 1.0;
      timer-state = "null";
      timer-state-date = "2021-09-20T11:32:33+0000";
      timer-state-duration = 0.0;
    };

    "org/gnome/settings-daemon/plugins/color" = {
      night-light-enabled = true;
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [ "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/" "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/" ];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Super>Return";
      command = "kgx";
      name = "Launch terminal";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      binding = "<Super>BackSpace";
      command = "ranger";
      name = "Launch ranger";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
      binding = "<Super>space";
      command = "gnome-terminal -e \"vim --cmd startinsert\"";
      name = "Launch scratchpad";
    };

    "org/gnome/settings-daemon/plugins/power" = {
      power-button-action = "suspend";
      sleep-inactive-ac-timeout = 7200;
      sleep-inactive-ac-type = "nothing";
    };

    "org/gnome/shell" = {
      command-history = [ "r" "webex" ];
      disable-user-extensions = false;
      disabled-extensions = [ "native-window-placement@gnome-shell-extensions.gcampax.github.com" "window-list@gnome-shell-extensions.gcampax.github.com" "places-menu@gnome-shell-extensions.gcampax.github.com" "user-theme@gnome-shell-extensions.gcampax.github.com" ];
      enabled-extensions = [ "apps-menu@gnome-shell-extensions.gcampax.github.com" "sound-output-device-chooser@kgshank.net" "bluetooth-quick-connect@bjarosze.gmail.com" "workspace-indicator@gnome-shell-extensions.gcampax.github.com" "launch-new-instance@gnome-shell-extensions.gcampax.github.com" ];
      favorite-apps = [ "org.gnome.Calendar.desktop" "org.gnome.Photos.desktop" "org.gnome.Nautilus.desktop" "chromium-browser.desktop" "spotify.desktop" "element-desktop.desktop" "firefox.desktop" ];
      had-bluetooth-devices-setup = true;
      last-selected-power-profile = "power-saver";
      welcome-dialog-last-shown-version = "40.1";
    };

    "org/gnome/shell/extensions/materialshell/layouts" = {
      gap = 4;
      screen-gap = 0;
      simple = false;
      simple-vertical = false;
      tween-time = 0.1;
    };

    "org/gnome/shell/extensions/materialshell/theme" = {
      clock-app-launcher = true;
      clock-horizontal = true;
      panel-icon-color = false;
      panel-icon-style = "hybrid";
      panel-size = 48;
      primary-color = "#3d3846";
      taskbar-item-style = "full";
      theme = "dark";
      vertical-panel-position = "left";
    };

    "org/gnome/shell/extensions/materialshell/tweaks" = {
      disable-notifications = true;
    };

    "org/gnome/shell/extensions/sound-output-device-chooser" = {
      ports-settings = ''
        {"version":3,"ports":[]}\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\n\\\\\\\\\\\\\\\\n\\\\\\\\n\\\\n\\n\n
      '';
    };

    "org/gnome/shell/extensions/trayIconsReloaded" = {
      icon-margin-horizontal = 4;
      icon-padding-horizontal = 0;
      icon-saturation = 100;
    };

    "org/gnome/shell/keybindings" = {
      switch-to-application-1 = [ "" ];
      switch-to-application-2 = [ "" ];
      switch-to-application-3 = [ "" ];
      switch-to-application-4 = [ "" ];
      switch-to-application-5 = [ "" ];
      switch-to-application-6 = [ "" ];
      switch-to-application-7 = [ "" ];
      switch-to-application-8 = [ "" ];
      switch-to-application-9 = [ "" ];
      toggle-application-view = [ "" ];
      toggle-overview = [ "" ];
    };

    "org/gnome/shell/weather" = {
      automatic-location = true;
      locations = "[<(uint32 2, <('Lund, Sweden', '', false, [(0.97219952452660785, 0.23026032653919404)], [(0.97040306410884714, 0.22689280275926285)])>)>]";
    };

    "org/gnome/shell/world-clocks" = {
      locations = "@av []";
    };

    "org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9" = {
      audible-bell = false;
      background-color = "rgb(46,52,54)";
      bold-is-bright = false;
      font = "JetBrains Mono 12";
      foreground-color = "rgb(211,215,207)";
      palette = [ "rgb(46,52,54)" "rgb(204,0,0)" "rgb(78,154,6)" "rgb(196,160,0)" "rgb(52,101,164)" "rgb(117,80,123)" "rgb(6,152,154)" "rgb(211,215,207)" "rgb(85,87,83)" "rgb(239,41,41)" "rgb(138,226,52)" "rgb(252,233,79)" "rgb(114,159,207)" "rgb(173,127,168)" "rgb(52,226,226)" "rgb(238,238,236)" ];
      use-system-font = false;
      use-theme-colors = false;
    };

    "org/gnome/tweaks" = {
      show-extensions-notice = false;
    };

    "org/gtk/gtk4/settings/color-chooser" = {
      custom-colors = [ (mkTuple [ 0.247059 0.317647 ]) ];
      selected-color = mkTuple [ true 0.239216 ];
    };

    "org/gtk/gtk4/settings/file-chooser" = {
      date-format = "regular";
      location-mode = "path-bar";
      show-hidden = false;
      show-size-column = true;
      show-type-column = true;
      sidebar-width = 168;
      sort-column = "name";
      sort-directories-first = false;
      sort-order = "ascending";
      type-format = "category";
      view-type = "list";
      window-size = mkTuple [ 853 374 ];
    };

    "org/gtk/settings/color-chooser" = {
      custom-colors = [ (mkTuple [ 4.4756e-2 0.14149 ]) (mkTuple [ 9.3733e-2 0.296329 ]) (mkTuple [ 1.7356e-2 0.178184 ]) (mkTuple [ 0.396078 0.482353 ]) ];
      selected-color = mkTuple [ true 0.0 ];
    };

    "org/gtk/settings/file-chooser" = {
      date-format = "regular";
      location-mode = "path-bar";
      show-hidden = false;
      show-size-column = true;
      show-type-column = true;
      sidebar-width = 148;
      sort-column = "modified";
      sort-directories-first = false;
      sort-order = "descending";
      type-format = "category";
      window-position = mkTuple [ 462 122 ];
      window-size = mkTuple [ 1124 822 ];
    };

    "org/virt-manager/virt-manager" = {
      manager-window-height = 520;
      manager-window-width = 550;
      xmleditor-enabled = true;
    };

    "org/virt-manager/virt-manager/confirm" = {
      forcepoweroff = true;
      removedev = false;
      unapplied-dev = true;
    };

    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };

    "org/virt-manager/virt-manager/conns/qemu:system" = {
      window-size = mkTuple [ 800 600 ];
    };

    "org/virt-manager/virt-manager/details" = {
      show-toolbar = true;
    };

    "org/virt-manager/virt-manager/new-vm" = {
      graphics-type = "system";
    };

    "org/virt-manager/virt-manager/paths" = {
      media-default = "/home/johanan/Downloads";
    };

    "org/virt-manager/virt-manager/vmlist-fields" = {
      disk-usage = false;
      network-traffic = false;
    };

    "org/virt-manager/virt-manager/vms/7385dc6f99c4438a9401bc7ee75818ce" = {
      autoconnect = 1;
      resize-guest = 1;
      scaling = 2;
      vm-window-size = mkTuple [ 1720 1384 ];
    };

    "system/proxy" = {
      mode = "none";
    };

  };
}
