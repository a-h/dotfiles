{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "uas" "sd_mod" ];
  boot.kernelModules = [ "kvm-amd" ];

  # A discrete NVIDIA GPU (primary display) alongside the AMD CPU's integrated
  # GPU, so both vendors' drivers are loaded. GPU compute (CUDA/ROCm) is not
  # configured yet; only display and gaming support is enabled.

  services.xserver.videoDrivers = [ "nvidia" ];
  boot.kernelParams = [
    "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
    "amdgpu.ppfeaturemask=0xf7fff"
    # nvidia-drm only loads ~7s into boot, so without this Plymouth waits for it
    # and the kernel log scrolls past in the meantime. simpledrm is up at ~1s.
    "plymouth.use-simpledrm=1"
  ];

  # A splash screen instead of the kernel log during boot. DeviceScale is
  # Plymouth's own HiDPI setting; it does not read monitors.xml.
  boot.plymouth.enable = true;
  boot.plymouth.extraConfig = ''
    DeviceScale=2
  '';
  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    nvidiaSettings = true;
    powerManagement.enable = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  hardware.amdgpu.initrd.enable = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # lact provides fan, power, and clock control for the AMD GPU.
  environment.systemPackages = with pkgs; [
    clinfo
    lact
  ];
  systemd.packages = [ pkgs.lact ];
  systemd.services.lactd.wantedBy = [ "multi-user.target" ];

  # The Bluetooth radio (Realtek RTL8852CU, 13d3:3586) sits on the board's
  # ASMedia-derived xHCI controller (1022:43f7, 0000:0e:00.0). That controller
  # fails its runtime-resume path: when it has autosuspended and something wakes
  # it - a device being plugged in, or the radio itself waking to take a
  # reconnection - the resume errors with "xHC error in resume, USBSTS 0x401,
  # Reinit", the kernel reinitialises the root hubs, and every device on the bus
  # is reset. Resetting the radio tears down its links, so paired devices drop,
  # and its scan engine can wedge until btusb resets the USB device and reloads
  # the firmware.
  #
  # Holding the radio and the controller at power/control=on keeps them out of
  # runtime suspend, so the broken resume path is never taken. This is a desktop,
  # so there is no battery to save. It does not cover resume from a system
  # suspend, which runs the same controller code regardless.
  #
  # The board's other xHCI controllers are 15b6, 15b7 and 15b8, so the PCI rule
  # matches only the faulty one.
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="13d3", ATTR{idProduct}=="3586", ATTR{power/control}="on"
    ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x1022", ATTR{device}=="0x43f7", ATTR{power/control}="on"
  '';

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
