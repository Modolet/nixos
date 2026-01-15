{ pkgs, ... }:
{
  imports = [
    ./dm/greetd.nix
    ./xdg.nix
    ./fonts.nix
  ];

  environment.systemPackages = [
    pkgs.xremap
  ];
  services = {
    # displayManager.gdm.enable = false;
    # desktopManager.gnome.enable = true;
    xserver = {
      enable = true;
      desktopManager.runXdgAutostartIfNone = true;
      xkb.layout = "us";
      xkb.variant = "";
    };

    flatpak.enable = true;
    fprintd = {
      enable = true;
    };

    printing.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    blueman.enable = true;

    udisks2.enable = true;
    gvfs.enable = true;
  };
  programs.dconf.enable = true;

}
