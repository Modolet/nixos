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
      nohup clash-verge >/dev/null 2>&1 < /dev/null &
      nohup OpenList server >/dev/null 2>&1 < /dev/null &
    '';

  };
in
{
  programs.niri.settings.spawn-at-startup = [
    { command = [ "${niri-autostart}/bin/niri-autostart" ]; }
  ];
}
