{ inputs }:
final: prev:
{
  niri = inputs.niri.packages.${prev.system}.niri-unstable;
}
