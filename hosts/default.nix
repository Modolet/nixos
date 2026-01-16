{
  self,
  inputs,
  ...
}:
{
  flake.nixosConfigurations =
    let
      inherit (inputs.nixpkgs.lib) nixosSystem;
      specialArgs = { inherit inputs self; };
    in
    {
      vmware = nixosSystem {
        inherit specialArgs;
        modules = [
          ./vmware
          ../system
          ../system/desktop
          inputs.stylix.nixosModules.stylix
          inputs.nur.modules.nixos.default
          {
            home-manager = {
              users.modolet.imports = with inputs; [
                dankMaterialShell.homeModules.dank-material-shell
                dankMaterialShell.homeModules.niri
                niri.homeModules.niri
                stylix.homeModules.stylix
                nixvim.homeModules.nixvim
                ./vmware/monitors.nix
                ../home
              ];
              extraSpecialArgs = specialArgs;
            };
          }
        ];
      };
      togo = nixosSystem {
        inherit specialArgs;
        modules = [
          ./togo
          ../system
          ../system/desktop
          inputs.stylix.nixosModules.stylix
          inputs.nur.modules.nixos.default
          {
            home-manager = {
              users.modolet.imports = with inputs; [
                dankMaterialShell.homeModules.dank-material-shell
                dankMaterialShell.homeModules.niri
                niri.homeModules.niri
                stylix.homeModules.stylix
                nixvim.homeModules.nixvim
                ./togo/monitors.nix
                ../home
              ];
              extraSpecialArgs = specialArgs;
            };
          }
        ];
      };
    };

}
