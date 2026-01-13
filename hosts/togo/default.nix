_: {
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "nixos_to_go";

  security = {
    forcePageTableIsolation = true;
    protectKernelImage = true;
    apparmor = {
      enable = true;
      killUnconfinedConfinables = true;
    };
  };

  hardware = {
    enableRedistributableFirmware = true;
  };

  systemd = {
    coredump.extraConfig = ''
      Storage=none
      ProcessSizeMax=0
    '';
  };

  specialisation = {
    intel-igpu.configuration = {
      services.xserver.videoDrivers = [
        "modesetting"
        "intel"
      ];
      hardware.cpu.intel.updateMicrocode = true;
    };
    amd-igpu.configuration = {
      services.xserver.videoDrivers = [
        "amdgpu"
      ];
      hardware.cpu.amd.updateMicrocode = true;
    };
    intel-nvidia.configuration = {
      services.xserver.videoDrivers = [
        "nvidia"
        "intel"
      ];
      hardware.cpu.intel.updateMicrocode = true;
      hardware.nvidia = {
        modesetting.enable = true;
        powerManagement.enable = true;
      };
    };
    amd-nvidia.configuration = {
      services.xserver.videoDrivers = [
        "nvidia"
        "amdgpu"
      ];
      hardware.cpu.amd.updateMicrocode = true;
      hardware.nvidia = {
        modesetting.enable = true;
        powerManagement.enable = true;
      };
    };
    intel-amd.configuration = {
      services.xserver.videoDrivers = [
        "amdgpu"
        "intel"
      ];
      hardware.cpu.intel.updateMicrocode = true;
    };
    amd-amd.configuration = {
      services.xserver.videoDrivers = [
        "amdgpu"
      ];
      hardware.cpu.amd.updateMicrocode = true;
    };
  };
}
