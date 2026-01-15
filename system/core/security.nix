{ ... }:
{
  security = {

    # allow wayland lockers to unlock the screen
    # userland niceness
    rtkit.enable = true;
    polkit.enable = true;

    sudo-rs = {
      enable = true;
      execWheelOnly = true;
      wheelNeedsPassword = false;
    };

    # don't ask for password for wheel group
    sudo = {
      wheelNeedsPassword = false;
    };

  };
}
