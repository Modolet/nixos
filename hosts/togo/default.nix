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

  services.xserver.videoDrivers = [
    "modesetting"
    "intel"
    "amdgpu"
    "nvidia"
  ];

  hardware.cpu.intel.updateMicrocode = true;
  hardware.cpu.amd.updateMicrocode = true;
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    open = true;
  };
}
