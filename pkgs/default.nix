{ inputs, ... }:
let
  overlays = import ./overlays;
  packages = import ./packages.nix;
in
{
  systems = [ "x86_64-linux" ];
  perSystem =
    { system, ... }:
    let
      pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = [
          overlays
          packages
        ];
        config = { };
      };
    in
    {
      _module.args.pkgs = pkgs;
    };

  flake.overlays = {
    default = overlays;
    inherit packages;
  };
}
