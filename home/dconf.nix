# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{ lib, ... }:

let
  mkTuple = lib.hm.gvariant.mkTuple;
in
{
  dconf.settings = {
    "org/gnome/cheese" = {
      burst-delay = 1000;
      camera = "USB 2.0 PC Camera: PC Camera";
      photo-x-resolution = 640;
      photo-y-resolution = 480;
      video-x-resolution = 640;
      video-y-resolution = 480;
    };

    "org/gnome/control-center" = {
      last-panel = "background";
    };

    "org/gnome/desktop/background" = {
      color-shading-type = "solid";
      picture-options = "zoom";
      picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/Loveles.jpg";
      primary-color = "#ffffff";
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
      enable-hot-corners = false;
      font-antialiasing = "grayscale";
      font-hinting = "slight";
      font-name = "Source Sans Variable 10";
      gtk-im-module = "gtk-im-context-simple";
      gtk-theme = "Numix";
      show-battery-percentage = true;
      toolkit-accessibility = false;
    };

    "org/gnome/desktop/notifications" = {
      application-children = [ "gnome-power-panel" "gnome-network-panel" "org-gnome-fileroller" "spotify" "element-desktop" "org-gnome-baobab" "slack" "org-gnome-terminal" "chromium-browser" "org-gnome-nautilus" "code" ];
      show-banners = true;
    };

    "org/gnome/desktop/notifications/application/chromium-browser" = {
      application-id = "chromium-browser.desktop";
    };

    "org/gnome/desktop/notifications/application/code" = {
      application-id = "code.desktop";
    };

    "org/gnome/desktop/notifications/application/com-uploadedlobster-peek" = {
      application-id = "com.uploadedlobster.peek.desktop";
    };

    "org/gnome/desktop/notifications/application/element-desktop" = {
      application-id = "element-desktop.desktop";
    };

    "org/gnome/desktop/notifications/application/gimp" = {
      application-id = "gimp.desktop";
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

    "org/gnome/desktop/notifications/application/wine-programs-remarkable-remarkable" = {
      application-id = "wine-Programs-reMarkable-reMarkable.desktop";
    };

    "org/gnome/desktop/peripherals/mouse" = {
      natural-scroll = false;
    };

    "org/gnome/desktop/peripherals/touchpad" = {
      tap-to-click = true;
      two-finger-scrolling-enabled = true;
    };

    "org/gnome/desktop/privacy" = {
      disable-microphone = false;
    };

    "org/gnome/desktop/screensaver" = {
      color-shading-type = "solid";
      picture-options = "zoom";
      picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/Loveles.jpg";
      primary-color = "#ffffff";
      secondary-color = "#000000";
    };

    "org/gnome/desktop/search-providers" = {
      sort-order = [ "org.gnome.Contacts.desktop" "org.gnome.Documents.desktop" "org.gnome.Nautilus.desktop" ];
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
      sidebar = false;
    };

    "org/gnome/eog/view" = {
      background-color = "rgb(0,0,0)";
      use-background-color = true;
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
      window-ratio = mkTuple [ 2.889416001988993 1.6724275142833387 ];
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
      toggle-tiled-left = [ "" ];
      toggle-tiled-right = [ "" ];
    };

    "org/gnome/mutter/wayland/keybindings" = {
      restore-shortcuts = [ "" ];
    };

    "org/gnome/nautilus/compression" = {
      default-compression-format = "zip";
    };

    "org/gnome/nautilus/preferences" = {
      default-folder-viewer = "icon-view";
      search-filter-time-type = "last_modified";
      search-view = "list-view";
    };

    "org/gnome/nautilus/window-state" = {
      initial-size = mkTuple [ 890 550 ];
      maximized = false;
      sidebar-width = 179;
    };

    "org/gnome/nm-applet/eap/10a0cf51-b7b6-4c8d-9d3d-2334fdcea9a8" = {
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

    "org/gnome/nm-applet/eap/6d5388ba-00c5-49db-b548-0462c816f23b" = {
      ignore-ca-cert = false;
      ignore-phase2-ca-cert = false;
    };

    "org/gnome/nm-applet/eap/7f453819-e859-47b2-b01f-4fabaa8c76d5" = {
      ignore-ca-cert = true;
      ignore-phase2-ca-cert = false;
    };

    "org/gnome/nm-applet/eap/bd3516bc-b218-4699-81d1-cb6f7337bb18" = {
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
      command = "gnome-terminal";
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
      sleep-inactive-ac-timeout = 7200;
    };

    "org/gnome/shell" = {
      command-history = [ "r" "webex" ];
      disabled-extensions = [ "native-window-placement@gnome-shell-extensions.gcampax.github.com" "window-list@gnome-shell-extensions.gcampax.github.com" "places-menu@gnome-shell-extensions.gcampax.github.com" "user-theme@gnome-shell-extensions.gcampax.github.com" ];
      enabled-extensions = [ "apps-menu@gnome-shell-extensions.gcampax.github.com" "sound-output-device-chooser@kgshank.net" "bluetooth-quick-connect@bjarosze.gmail.com" "workspace-indicator@gnome-shell-extensions.gcampax.github.com" "launch-new-instance@gnome-shell-extensions.gcampax.github.com" ];
      favorite-apps = [ "org.gnome.Calendar.desktop" "org.gnome.Photos.desktop" "org.gnome.Nautilus.desktop" "chromium-browser.desktop" "spotify.desktop" "org.gnome.Terminal.desktop" "element-desktop.desktop" "slack.desktop" ];
      had-bluetooth-devices-setup = true;
      welcome-dialog-last-shown-version = "40.1";
    };

    "org/gnome/shell/world-clocks" = {
      locations = "@av []";
    };

    "org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9" = {
      audible-bell = false;
      background-color = "rgb(46,52,54)";
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
      window-position = mkTuple [ 0 32 ];
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

    "org/virt-manager/virt-manager/urls" = {
      isos = [ "/home/johanan/Downloads/ubuntu-20.04.4-desktop-amd64.iso" ];
      urls = [ "https://releases.ubuntu.com/20.04/ubuntu-20.04.4-desktop-amd64.iso" ];
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

  };
}
