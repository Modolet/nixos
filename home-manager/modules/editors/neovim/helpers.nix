{ lib, pkgs }:

rec {
  # 基础的extra定义函数
  mkExtra = { plugins ? [ ], lspServers ? [ ], grammars ? [ ], importPath
    , defaultEnabled ? false }: {
      inherit plugins lspServers grammars importPath defaultEnabled;
    };

  # 语言相关extra的特化函数
  mkLangExtra =
    { plugins ? [ ], lspServers ? [ ], grammars, lang, defaultEnabled ? false }:
    mkExtra {
      inherit plugins lspServers grammars defaultEnabled;
      importPath = "lazyvim.plugins.extras.lang.${lang}";
    };

  # 编码相关extra的特化函数
  mkCodingExtra = { plugins ? [ ], lspServers ? [ ], grammars ? [ ], name
    , defaultEnabled ? false }:
    mkExtra {
      inherit plugins lspServers grammars defaultEnabled;
      importPath = "lazyvim.plugins.extras.coding.${name}";
    };

  # 编辑器相关extra的特化函数
  mkEditorExtra = { plugins ? [ ], lspServers ? [ ], grammars ? [ ], name
    , defaultEnabled ? false }:
    mkExtra {
      inherit plugins lspServers grammars defaultEnabled;
      importPath = "lazyvim.plugins.extras.editor.${name}";
    };

  # UI相关extra的特化函数
  mkUIExtra = { plugins ? [ ], lspServers ? [ ], grammars ? [ ], name
    , defaultEnabled ? false }:
    mkExtra {
      inherit plugins lspServers grammars defaultEnabled;
      importPath = "lazyvim.plugins.extras.ui.${name}";
    };

  # AI相关extra的特化函数
  mkAIExtra = { plugins ? [ ], lspServers ? [ ], grammars ? [ ], name
    , defaultEnabled ? false }:
    mkExtra {
      inherit plugins lspServers grammars defaultEnabled;
      importPath = "lazyvim.plugins.extras.ai.${name}";
    };

  # 其他分类的特化函数 - 支持自定义importPath
  mkCategoryExtra = category:
    { plugins ? [ ], lspServers ? [ ], grammars ? [ ], name
    , defaultEnabled ? false, importPath ? null }:
    mkExtra {
      inherit plugins lspServers grammars defaultEnabled;
      importPath = if importPath != null then
        importPath
      else
        "lazyvim.plugins.extras.${category}.${name}";
    };

  # 优化的集合操作函数
  collectFromExtras = field: extras:
    lib.unique (lib.concatMap (extra: extra.${field}) (lib.attrValues extras));

  # 生成选项的辅助函数
  mkExtraOptions = category: extras:
    lib.mapAttrs (name: extra: {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = extra.defaultEnabled or false;
        description = "Enable LazyVim ${category}.${name} extra";
      };
    }) extras;

  # 获取启用的extras
  getEnabledExtras = cfg: category:
    let categoryExtras = cfg.extrasDefinitions.${category} or { };
    in lib.filterAttrs (name: extra: cfg.extras.${category}.${name}.enable)
    categoryExtras;

  # 收集所有启用的extras
  getAllEnabledExtras = cfg:
    lib.foldl (acc: category:
      acc // (lib.mapAttrs'
        (name: extra: lib.nameValuePair "${category}.${name}" extra)
        (getEnabledExtras cfg category))) { }
    (lib.attrNames cfg.extrasDefinitions);

  # 生成import字符串
  generateImports = extras:
    let
      importList =
        lib.mapAttrsToList (_: extra: ''{ import = "${extra.importPath}" }'')
        extras;
    in if importList == [ ] then
      ""
    else
      lib.concatStringsSep ",\n            " importList;

  # 处理插件条目
  mkEntryFromDrv = drv:
    if lib.isDerivation drv then {
      name = "${lib.getName drv}";
      path = drv;
    } else
      drv;

  # 创建lazy路径
  createLazyPath = pkgs: allPlugins:
    pkgs.linkFarm "lazy-plugins" (builtins.map mkEntryFromDrv allPlugins);

  # 插件简化函数
  vimPlugins = name: pkgs.vimPlugins.${name};

  # mini插件特殊处理
  miniPlugin = name: {
    name = "mini.${name}";
    path = pkgs.vimPlugins.mini-nvim;
  };

  # 常用包引用简化
  withPkgs = names: builtins.map (name: pkgs.${name}) names;
  withVimPlugins = names: builtins.map (name: pkgs.vimPlugins.${name}) names;
}

