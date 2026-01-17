{
  config,
  pkgs,
  ...
}:
{
  boot = {
    bootspec.enable = false;

    initrd = {
      systemd.enable = false;
    };
    supportedFilesystems = [ "ntfs" ];

    # use latest kernel
    kernelPackages = pkgs.linuxPackages_latest;

    consoleLogLevel = 3;
    kernelParams = [
      "systemd.show_status=auto"
      "rd.udev.log_level=3"
      "plymouth.use-simpledrm"
    ];

    loader = {
      systemd-boot.enable = false;
      grub = {
        theme = pkgs.catppuccin-grub;
        enable = true;
        device = "nodev";
        efiSupport = true;
        # efiInstallAsRemovable = true;
      };
      efi.canTouchEfiVariables = true;
    };

    plymouth.enable = true;

    tmp = {
      useTmpfs = true;
      cleanOnBoot = true;
    };
  };
  systemd.services.nix-daemon = {
    environment = {
      TMPDIR = "/var/tmp";
    };
  };
  environment.systemPackages = [ config.boot.kernelPackages.cpupower ];
}
