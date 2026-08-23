{
  disko.devices.disk = {
    nvme0 = {
      type = "disk";
      device = "/dev/nvme0n1";
      content = {
        type = "gpt";
        partitions = {
          boot = {
            label = "boot";
            type = "EF00"; # EFI System Partition
            size = "2G";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "umask=0077" ];
            };
          };
          swap = {
            label = "swap";
            type = "8200"; # Linux swap
            size = "32G";
            content = {
              type = "swap";
            };
          };
          nixos = {
            label = "nixos";
            size = "100%";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
            };
          };
        };
      };
    };
  };
}
