{ inputs }:
final: prev:
{
  niri = inputs.niri.packages.${prev.system}.niri-unstable.override {
    replace-service-with-usr-bin = true;
  };
}
