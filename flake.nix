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

    # Niri Wayland 合成器
    niri.url = "github:sodiboo/niri-flake";
    niri.inputs.nixpkgs.follows = "nixpkgs";

    # Stylix 主题系统
    stylix.url = "github:danth/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";

    # swhkd 快捷键守护进程
    swhkd.url = "github:waycrate/swhkd";
    swhkd.inputs.nixpkgs.follows = "nixpkgs";

    # 字体包
    kose-font = {
      url = "github:Biro-Biro/Font-Kose";
      flake = false;
    };

    hugmetight-font = {
      url = "github:EliverLara/HugMeTight";
      flake = false;
    };

    # Material Symbols 图标
    material-symbols.url = "github:googlefonts/material-symbols";
    material-symbols.flake = false;
  };

  # 输出定义
  outputs = { self, nixpkgs, home-manager, nixvim, niri, stylix, swhkd, kose-font, hugmetight-font, material-symbols, ... }@inputs:
    let
      # 系统架构
      system = "x86_64-linux";

      # nixpkgs 实例
      pkgs = nixpkgs.legacyPackages.${system};

      # 库函数
      lib = import ./lib { inherit pkgs; };

      # 自定义 overlay
      overlay = final: prev: {
        # 字体包
        kose-font = final.callPackage ./packages/kose-font.nix {
          src = kose-font;
        };

        hugmetight-font = final.callPackage ./packages/hugmetight-font.nix {
          src = hugmetight-font;
        };

        # Material Symbols
        material-symbols = final.callPackage ./packages/material-symbols.nix {
          src = material-symbols;
        };

        # Niri (unstable 版本)
        niri-unstable = niri.packages.${final.system}.niri;

        # swhkd
        swhkd = swhkd.packages.${final.system}.swhkd;
      };

    in {
      # NixOS 系统配置
      nixosConfigurations = {
        vm-nixos = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            { nixpkgs.overlays = [ overlay ]; }
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
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ overlay ];
          };
          extraSpecialArgs = { inherit inputs; };
          modules = [
            nixvim.homeModules.nixvim
            ./home-manager/users/modolet.nix
          ];
        };
      };
    };
}