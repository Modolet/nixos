{
  description = "NixOS 配置 - 模块化多用户多设备管理";

  # 输入定义
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # 输出定义
  outputs = { self, nixpkgs, home-manager, nixvim, ... }@inputs:
    let
      # 系统架构
      system = "x86_64-linux";

      # nixpkgs 实例
      pkgs = nixpkgs.legacyPackages.${system};

      # 库函数
      lib = import ./lib { inherit pkgs; };

      # 自定义 overlay
      overlay = final: prev: {
        # 可以在这里添加自定义包
      };

    in {
      # NixOS 系统配置
      nixosConfigurations = {
        vm-nixos = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/vm/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useUserPackages = true;
                useGlobalPkgs = true;
                extraSpecialArgs = { inherit inputs; };

                # 导入 nixvim 的 Home Manager 模块
                sharedModules = [ nixvim.homeModules.nixvim ];

                users.modolet = {
                  imports = [
                    ./home-manager/users/modolet.nix
                  ];
                };
              };
            }
          ];
          specialArgs = { inherit inputs; };
        };
      };

      # Home-manager 用户配置
      homeConfigurations = {
        modolet = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit inputs; };
          modules = [
            nixvim.homeModules.nixvim
            ./home-manager/users/modolet.nix
          ];
        };
      };
    };
}