# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, ... }:

{
  imports =
    [ <nixpkgs/nixos/modules/profiles/qemu-guest.nix>
    ];

  boot.initrd.availableKernelModules = [ "ata_piix" "floppy" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/2015fafb-e976-4c67-9d17-77f3ffd81092";
      fsType = "ext4";
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/3a9ab2e3-4d58-4e1a-ae5d-c983467e5919";
      fsType = "ext4";
    };

  fileSystems."/boot/efi" =
    { device = "/dev/disk/by-uuid/1BC5-4191";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/598b5e3c-9707-4fb8-86c4-3caceadb2c0b"; }
    ];

  nix.maxJobs = lib.mkDefault 1;
}
