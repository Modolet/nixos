{ pkgs, ... }:
{
  users.users.modolet = {
    isNormalUser = true;
    shell = pkgs.nushell;
    extraGroups = [
      "adbusers"
      "docker"
      "input"
      "uinput"
      "libvirtd"
      "networkmanager"
      "plugdev"
      "video"
      "wheel"
      "kvm"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP00CkeuZvXz7sjCwZeiXU9eEn3FGUo+Gfz9FfDNaPho modolet y@xxyx.io"
    ];
  };

  users.users.root = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP00CkeuZvXz7sjCwZeiXU9eEn3FGUo+Gfz9FfDNaPho modolet y@xxyx.io"
    ];
  };
}
