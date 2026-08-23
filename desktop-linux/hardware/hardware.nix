{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "uas" "sd_mod" ];
  boot.kernelModules = [ "kvm-amd" ];

  # A discrete NVIDIA GPU (primary display and CUDA) alongside the AMD CPU's
  # integrated GPU (OpenCL/ROCm compute), so both vendors' drivers are loaded.

  services.xserver.videoDrivers = [ "nvidia" ];
  boot.kernelParams = [
    "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
    "amdgpu.ppfeaturemask=0xf7fff"
  ];
  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    nvidiaSettings = true;
    powerManagement.enable = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  hardware.amdgpu = {
    initrd.enable = true;
    opencl.enable = true;
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      rocmPackages.clr.icd
    ];
  };

  # Some tools expect ROCm libraries at the fixed path /opt/rocm.
  systemd.tmpfiles.rules =
    let
      rocmEnv = pkgs.symlinkJoin {
        name = "rocm-combined";
        paths = with pkgs.rocmPackages; [
          rocblas
          hipblas
          clr
        ];
      };
    in
    [
      "L+    /opt/rocm   -    -    -     -    ${rocmEnv}"
    ];

  # lact provides fan, power, and clock control for the AMD GPU.
  environment.systemPackages = with pkgs; [
    clinfo
    lact
  ];
  systemd.packages = [ pkgs.lact ];
  systemd.services.lactd.wantedBy = [ "multi-user.target" ];

  hardware.nvidia-container-toolkit.enable = true;

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
