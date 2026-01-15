{ inputs }:
final: prev:
{
  niri =
    let
      pkgs25_11 = import inputs.nixpkgs-stable {
        inherit (prev) system config;
      };
    in
    pkgs25_11.niri;
}
