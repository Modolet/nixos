_: {
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "vm_nixos";

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
    cpu.amd.updateMicrocode = true;
  };

  systemd = {
    coredump.extraConfig = ''
      Storage=none
      ProcessSizeMax=0
    '';
  };
}
