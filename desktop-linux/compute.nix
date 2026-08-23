# cudaSupport and rocmSupport are set at the nixpkgs level in the flake, so
# packages such as blender, opencv, and torch are built with GPU acceleration.
# This module installs the toolkits and monitoring tools themselves.
{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    cudatoolkit
    cudaPackages.cuda_nvcc
    rocmPackages.rocminfo
    rocmPackages.rocm-smi
    nvtopPackages.full
  ];
}
