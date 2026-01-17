{ pkgs, ... }:
{
  virtualisation = {
    docker.enable = true;
    podman.enable = true;
    libvirtd = {
      enable = true;
      qemu.package = pkgs.qemu_kvm;
    };
    spiceUSBRedirection.enable = true;
  };

  programs.virt-manager.enable = true;

  environment.systemPackages = [
    pkgs.qemu_kvm
  ];
}
