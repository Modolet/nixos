{ inputs, ... }:
let
  overlays = import ./overlays { inherit inputs; };
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
          inputs.nur.overlay
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
    nur = inputs.nur.overlay;
  };
}
