{ pkgs, ... }:

{
  # The web configurator at app.betaflight.com drives the flight controller from
  # inside the page, which needs Web Serial, Web USB or Web Bluetooth. Mozilla
  # has taken a formal "harmful" position on all three specs and implements none
  # of them, so Firefox - the only browser here, see firefox.nix - can only show
  # "Betaflight requires a browser with at least one of: Web Serial, Web
  # Bluetooth, or Web USB". The desktop build is the same application in a shell
  # that provides those transports natively, so it is installed instead of
  # adding a second browser.
  #
  # Built from source rather than taken from nixpkgs: see the header of
  # pkgs/betaflight-configurator.nix for why.
  environment.systemPackages = [
    (pkgs.callPackage ./pkgs/betaflight-configurator.nix { })
    # dfu-util is upstream's own answer to flashing on Linux: the devcontainer
    # guide in the betaflight firmware repo builds with make and flashes with
    # `make dfu_flash`, which is `echo -n 'R' > /dev/ttyACM0` to reboot the board
    # over MSP and then dfu-util against the 0483:df11 device it comes back as.
    # That needs no browser engine at all, so it works here where the app's own
    # flashing does not.
    pkgs.dfu-util
  ];

  # Connecting to a running board needs no rule. It enumerates as USB CDC ACM,
  # cdc_acm gives it /dev/ttyACM0 owned by group dialout, users.nix already puts
  # adrian in dialout, and the desktop build reaches it through
  # tauri-plugin-serialplugin rather than through a browser API.
  #
  # Flashing is the part these rules are for, and they do nothing for the
  # desktop build - see the caveat in pkgs/betaflight-configurator.nix, which
  # has no working DFU path on Linux. They apply to the routes that do flash:
  # the web configurator in a Chromium browser, and the old NW.js build still in
  # nixpkgs. Both open the device node directly, because a board held in its
  # bootloader leaves the serial bus and comes back as a bare DFU device with no
  # tty behind it, so dialout stops applying.
  #
  # The uaccess tag has systemd-logind put an ACL for that node on whoever holds
  # the local seat, which is narrower than a fixed group or a 0666 mode and
  # needs no group NixOS would have to be told to create.
  #
  # These are the six DFU bootloader IDs in src/js/protocols/devices.js at
  # 2026.6.1, one per MCU family. The serial VID/PIDs listed alongside them
  # there are deliberately not repeated: dialout already covers those. Note that
  # loadDeviceFilters() in the same file replaces the built-in list with one
  # fetched from Betaflight's build API at startup, so a board added upstream
  # can need a rule here that this list does not predict.
  services.udev.extraRules = ''
    # STM32
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", TAG+="uaccess"
    # GD32
    SUBSYSTEM=="usb", ATTRS{idVendor}=="28e9", ATTRS{idProduct}=="0189", TAG+="uaccess"
    # AT32F435
    SUBSYSTEM=="usb", ATTRS{idVendor}=="2e3c", ATTRS{idProduct}=="df11", TAG+="uaccess"
    # APM32
    SUBSYSTEM=="usb", ATTRS{idVendor}=="314b", ATTRS{idProduct}=="0106", TAG+="uaccess"
    # Raspberry Pi Pico
    SUBSYSTEM=="usb", ATTRS{idVendor}=="2e8a", ATTRS{idProduct}=="000f", TAG+="uaccess"
    # X32
    SUBSYSTEM=="usb", ATTRS{idVendor}=="3997", ATTRS{idProduct}=="df11", TAG+="uaccess"
  '';
}
