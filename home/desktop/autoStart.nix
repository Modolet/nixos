{ pkgs, ... }:
let
  niri-autostart = pkgs.writeShellApplication {
    name = "niri-autostart";
    runtimeInputs = [ ];
    extraShellCheckFlags = [ ];
    bashOptions = [ ];
    text = ''
      set -euo pipefail

      systemctl --user restart xremap.service || true
      fcitx5 -d -r &
    '';

  };
in
{
  programs.niri.settings.spawn-at-startup = [
    { command = [ "${niri-autostart}/bin/niri-autostart" ]; }
  ];
}
