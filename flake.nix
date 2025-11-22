{
  description = "NixOS 配置 - 模块化多用户多设备管理";

  # 输入定义
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # 输出定义
  outputs = { self, nixpkgs, home-manager, nixvim, ... }:
    let
      # 系统架构
      system = "x86_64-linux";

      # nixpkgs 实例
      pkgs = nixpkgs.legacyPackages.${system};

    in {
      # NixOS 系统配置
      nixosConfigurations = {
        vm-nixos = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/vm/configuration.nix
            home-manager.nixosModules.home-manager
          ];
          specialArgs = {
            inherit self nixvim;
          };
        };
      };

      # Home-manager 用户配置
      homeConfigurations = {
        modolet = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit nixvim; };
          modules = [
            nixvim.homeModules.nixvim
            ./home-manager/users/modolet.nix
          ];
        };
      };
    };
}