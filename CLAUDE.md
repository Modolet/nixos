# NixOS 配置结构设计文档

## 概述

本文档描述了一个模块化、可扩展的 NixOS 配置结构设计，支持多用户、多设备场景，使用 flake 和 home-manager 进行管理。

## 系统版本

**当前 NixOS 系统版本**：25.05

所有配置文件中的 `system.stateVersion` 和 `home.stateVersion` 都应设置为 `25.05`，确保配置的一致性和兼容性。

## 设计原则

### 1. 模块化设计 (Modularity)
- **理念**：将复杂配置分解为独立的、可重用的模块
- **实现**：每个模块专注于单一职责，模块间依赖关系清晰
- **优势**：易于调试、可重用、独立更新

### 2. 关注点分离 (Separation of Concerns)
- **系统 vs 用户配置**：系统配置由管理员管理，用户配置由用户自定义
- **硬件 vs 软件**：硬件配置设备特定，软件配置通用
- **通用 vs 特定**：通用模块所有机器共享，特定配置主机或用户独有

### 3. 可扩展性 (Scalability)
- **水平扩展**：新增主机、用户、模块都只需要添加相应文件
- **垂直扩展**：模块层次化，支持配置继承

### 4. 声明式配置 (Declarative Configuration)
- **配置即代码**：所有配置都是 Nix 表达式
- **幂等性**：多次应用配置结果一致

## 目录结构框架

```
nixos/
├── flake.nix                     # flake 入口文件，定义所有配置和输出
├── .gitignore                    # git 忽略文件配置
├── README.md                     # 项目说明文档
├── CLAUDE.md                     # 本配置设计文档
│
├── home-manager/                 # home-manager 配置目录
│   ├── modules/                  # 共享的 home-manager 模块
│   │   ├── common.nix            # 通用配置模块
│   │   └── [其他模块]            # 按需添加的功能模块
│   │
│   └── users/                    # 用户特定配置
│       └── [用户名].nix          # 各用户的完整配置文件
│
├── modules/                      # NixOS 系统模块
│   ├── hardware/                 # 硬件相关模块
│   │   └── [硬件模块].nix        # 各种硬件配置模块
│   │
│   ├── services/                 # 系统服务配置
│   │   └── [服务模块].nix        # 各种系统服务配置
│   │
│   ├── desktop/                  # 桌面环境配置（如果使用）
│   │   └── [桌面环境].nix        # 各种桌面环境配置
│   │
│   ├── security/                 # 安全相关配置
│   │   └── [安全模块].nix        # 各种安全配置模块
│   │
│   ├── development/              # 开发环境配置（如果需要）
│   │   └── [开发模块].nix        # 各种开发环境配置
│   │
│   └── common.nix                # 通用系统配置
│
├── hosts/                        # 主机配置目录
│   └── [主机名]/                 # 各主机的配置目录
│       ├── hardware.nix          # 硬件特定配置
│       ├── configuration.nix     # 系统配置
│       ├── home.nix              # 该主机用户的 home 配置引用
│       └── special-config.nix    # 该主机特殊配置（可选）
│
├── packages/                     # 自定义包目录（可选）
│   ├── default.nix               # 包集合入口文件
│   ├── overlays/                 # 包覆盖配置
│   │   └── default.nix           # 覆盖定义
│   └── [自定义包]                # 各种自定义软件包
│
├── secrets/                      # 敏感信息目录（使用 agenix 管理）
│   ├── .gitkeep                  # 保持目录结构
│   └── [敏感信息].nix            # 各种敏感信息配置
│
└── docs/                         # 文档目录（可选）
    └── [文档文件].md             # 各种说明文档
```

## 配置层次结构

### 1. flake.nix - 配置入口
- 定义所有输入（nixpkgs, home-manager 等）
- 定义所有输出（nixosConfigurations, homeConfigurations 等）
- 作为整个配置的入口点

### 2. 主机配置层 (hosts/)
每个主机包含：
- `hardware.nix`：硬件特定配置
- `configuration.nix`：系统配置
- `home.nix`：用户配置引用
- `special-config.nix`：主机特殊配置（可选）

### 3. 模块层 (modules/, home-manager/modules/)
**系统模块**：
- 硬件支持
- 系统服务
- 安全配置
- 其他系统级功能

**用户模块**：
- 应用程序配置
- 开发工具
- 终端环境
- 其他用户级功能

### 4. 基础层
**包定义** (packages/)：
- 自定义软件包
- 包覆盖
- 脚本集合

## 多用户支持策略

### 1. 用户配置隔离
每个用户有独立的配置文件：`home-manager/users/[用户名].nix`

### 2. 共享模块
用户间可共享通用模块：通过 `imports` 引用 `home-manager/modules/` 中的模块

### 3. 主机用户映射
在 `flake.nix` 中为每个主机配置对应的用户

## 多设备支持策略

### 1. 硬件抽象
将硬件特定配置分离到 `hosts/[主机名]/hardware.nix`

### 2. 配置组合
每个主机通过组合不同模块实现差异化配置

### 3. 条件配置
基于设备类型或属性应用不同配置

## 安全性考虑

### 1. 敏感信息管理
使用 `agenix` 等工具管理 `secrets/` 目录中的敏感信息

### 2. 权限分离
- 系统配置：需要 root 权限
- 用户配置：用户权限即可
- 包管理：系统级包 vs 用户级包

## 最佳实践

### 1. 命名约定
- 文件名使用小写字母和连字符
- 目录名描述性强
- 配置项语义化命名

### 2. 文档维护
- 每个模块包含注释说明用途
- 复杂配置提供示例
- 维护变更日志

### 3. 版本管理
- 使用 Git 进行版本控制
- 定期备份重要配置
- 标记稳定的配置版本

## 使用流程

### 1. 新增设备
1. 在 `hosts/` 下创建新主机目录
2. 配置硬件和系统设置
3. 在 `flake.nix` 中添加主机配置
4. 应用配置到新设备

### 2. 新增用户
1. 在 `home-manager/users/` 下创建用户配置文件
2. 引用需要的共享模块
3. 在相应主机配置中添加用户
4. 应用用户配置

### 3. 新增功能模块
1. 在相应 `modules/` 目录下创建模块文件
2. 定义模块配置选项
3. 在需要的主机或用户配置中引用
4. 测试模块功能

这个框架结构提供了灵活的基础，可以根据实际需求逐步添加具体的功能模块和配置。

## 当前实现状态

### 已完成的配置结构

#### 1. 核心配置文件
- **[flake.nix](flake.nix)**: 配置入口文件，定义 nixpkgs 和 home-manager 输入，支持 `vm-nixos` 主机配置
- **[modules/common.nix](modules/common.nix)**: 通用系统配置，包含 SSH、网络、国际化、基础包等
- **[home-manager/modules/common.nix](home-manager/modules/common.nix)**: 通用用户配置，包含基础包和环境变量

#### 2. 用户配置
- **[home-manager/users/modolet.nix](home-manager/users/modolet.nix)**: modolet 用户的完整配置，引用通用模块

#### 3. 主机配置 (vm-nixos)
- **[hosts/vm/hardware.nix](hosts/vm/hardware.nix)**: VMware 虚拟机硬件配置
- **[hosts/vm/configuration.nix](hosts/vm/configuration.nix)**: 虚拟机系统配置，包含 EFI 启动、VMware tools 等
- **[hosts/vm/home.nix](hosts/vm/home.nix)**: 虚拟机用户配置引用

### 配置特性

#### 1. SSH 认证配置
- **Root 访问**: `PermitRootLogin yes` 允许 root 用户 SSH 登录
- **密码认证**: `PasswordAuthentication true` 支持密码登录
- **密钥认证**: 已配置 SSH 公钥认证，避免重复密码输入
- **安全设置**: `PermitEmptyPasswords false` 禁止空密码

#### 2. 启动配置
- **EFI 支持**: GRUB 配置支持 EFI 启动 (`efiSupport = true`)
- **设备配置**: `device = "nodev"` 适用于虚拟化环境

#### 3. VMware 虚拟机支持
- **VMware Guest**: 启用 VMware guest 增强功能
- **Open VM Tools**: 安装并配置 `open-vm-tools` 包
- **VMware 服务**: `vmware.service` 正常运行

## 部署和维护流程

### 1. 新设备部署流程
以 VMware 虚拟机为例：
1. **创建硬件配置**: `hosts/[主机名]/hardware.nix`
2. **创建系统配置**: `hosts/[主机名]/configuration.nix`
3. **创建用户配置**: `hosts/[主机名]/home.nix`
4. **配置 SSH 认证**: 将 SSH 公钥添加到配置中
5. **部署配置**: `nixos-rebuild switch --flake .#主机名`

### 2. 配置更新流程
1. **本地修改**: 在相应配置文件中进行更改
2. **测试配置**: 使用 `nix flake check` 验证语法
3. **部署更新**: `nixos-rebuild switch --flake .#主机名`
4. **提交变更**: `git add . && git commit -m "描述变更" && git push`

### 3. SSH 密钥管理
1. **获取本地公钥**: `cat ~/.ssh/id_rsa.pub`
2. **添加到配置**: 将公钥添加到 `users.users.root.openssh.authorizedKeys.keys`
3. **配置到目标机**: 手动添加到目标机的 `~/.ssh/authorized_keys`
4. **验证无密码登录**: 测试 SSH 连接

## 文档维护策略

### 1. 文档更新原则
- **实时同步**: 每次重要配置变更后立即更新 CLAUDE.md
- **结构一致性**: 确保文档结构与实际配置文件结构一致
- **示例完整性**: 为每个模块和配置提供完整的使用示例

### 2. 版本控制
- **配置变更**: 所有配置变更都应在 CLAUDE.md 中记录
- **流程更新**: 部署和维护流程的任何修改都应体现在文档中
- **结构演进**: 目录结构的变化需要及时更新到文档中

### 3. 文档自我引用
本节内容本身就是对文档维护策略的实践，确保：
- 每次更新 CLAUDE.md 时都记录此行为
- 维护流程本身被文档化
- 新的维护者能够理解如何保持文档的准确性

## 问题处理策略

### 遇到无法解决的问题时的处理原则

当遇到以下情况时，必须停止盲目尝试，主动寻求用户指导：

1. **配置部署失败且原因不明**：
   - 无法确定是配置语法错误还是版本兼容性问题
   - 错误信息指向 nixvim 或其他外部工具的内部问题

2. **架构设计不明确**：
   - 不清楚如何正确集成第三方模块（如 nixvim）
   - 对配置的架构设计存在疑问

3. **版本兼容性问题**：
   - 不确定哪个版本的包是稳定的
   - 出现版本冲突或依赖问题

4. **超出知识范围的问题**：
   - 涉及未知的 NixOS 功能或配置选项
   - 需要特定的硬件或系统知识

### 标准处理流程

1. **停止当前尝试**：立即停止在不确定的方向上继续尝试
2. **记录问题现状**：
   - 当前的配置状态
   - 遇到的具体错误信息
   - 已尝试的解决方案
3. **向用户说明情况**：
   - 清晰描述遇到的问题
   - 说明不确定的原因
   - 询问应该如何处理
4. **等待明确指示**：不继续任何配置修改，直到获得明确的指导

### 示例

**错误做法**：
- 反续尝试不同的配置语法
- 随意修改配置文件
- 希望"试一试就能成功"

**正确做法**：
- "nixvim 部署失败，错误信息指向内部配置问题，我无法确定是语法错误还是版本兼容性问题。应该如何处理？"
- "我不确定在 NixOS 25.05 中启用 nixvim 的正确方式，需要你的指导。"

## 参考配置分析

### 1. Modolet/dotfiles - Neovim 配置参考

**仓库特点**：
- 基于 Nix 的 dotfiles 管理
- 75.7% Nix + 22.8% Lua，表明 neovim 配置主要通过 Nix 定义，辅以 Lua 配置
- 简洁的目录结构：hosts/ 和 modules/ 目录

**Neovim 配置策略**：
- 将 neovim 配置作为 home-manager 模块的一部分
- 使用 Nix 定义 neovim 插件和配置
- Lua 文件用于具体的 neovim 配置细节

**建议的 Neovim 配置结构**：
```
home-manager/modules/
├── editors/
│   ├── neovim.nix              # Nix 定义的 neovim 配置
│   └── neovim/                 # neovim 的 Lua 配置文件
│       ├── init.lua            # neovim 主配置
│       ├── plugins/            # 插件配置目录
│       ├── keymaps/            # 按键映射
│       └── lsp/                # LSP 配置
```

### 2. EdenQwQ/nixos - 桌面环境配置参考

**仓库结构分析**：
```
nixos/
├── home/                       # 用户配置目录
├── hosts/                      # 机器特定配置
├── os/                         # 基础系统配置
├── modules/home-manager/       # 可重用的 home-manager 模块
├── overlays/                   # 包定制覆盖
├── pkgs/                       # 自定义包
└── secrets/                    # 安全数据
```

**配置特点**：
- 明确的关注点分离：home（用户）、os（系统）、hosts（机器）
- 模块化的 home-manager 配置
- 支持包覆盖和自定义包
- 敏感信息单独管理

**桌面环境配置策略**：
- 桌面环境配置放在 `modules/home-manager/` 中
- 机器特定的硬件和显示配置放在 `hosts/` 中
- 通过模块组合实现不同桌面的差异化

### 3. 综合配置建议

基于两个参考配置，建议采用以下混合策略（保持之前的目录结构框架）：

**Neovim 配置实现**：
1. 在 `home-manager/modules/editors/neovim.nix` 中使用 Nix 定义插件和基础配置
2. 在 `home-manager/modules/editors/neovim/` 目录中放置具体的 Lua 配置文件
3. 通过 home-manager 模块系统管理和分发配置

**桌面环境配置实现**：
1. 在 `modules/desktop/` 中定义系统级桌面环境配置
2. 在 `home-manager/modules/desktop/` 中定义用户级桌面应用和主题配置
3. 在 `hosts/` 中根据硬件特性选择合适的桌面环境

这种结构结合了两个参考配置的优点：Modolet 的 neovim 配置方法和 EdenQwQ 的整体架构设计，同时保持了之前定义的统一目录结构框架。

## Git 工作流程

### 1. 仓库配置

**远程仓库**：
- 地址：`git@github.com:Modolet/nixos.git`
- 分支：`master`
- 推送策略：每次修改后立即推送

**用户信息**：
- 提交者：modolet
- 提交信息：使用中文，简洁描述变更内容

### 2. 工作流程

**每次修改的标准流程**：
1. **修改文件**：进行配置或文档的修改
2. **添加文件**：`git add .` 添加所有修改到暂存区
3. **提交变更**：`git commit -m "中文提交信息"`
4. **推送到远程**：`git push`

### 2. 提交信息规范

#### 提交信息格式
遵循 **类型(范围): 描述** 的格式，其中：
- **类型**: 必需，表示变更的性质
- **范围**: 可选，表示影响的功能模块或文件
- **描述**: 必需，简洁明了的中文描述

#### 类型 (Type) 定义
| 类型 | 说明 | 示例 |
|------|------|------|
| `feat` | 新功能 (feature) | `feat: 添加 modolet 用户配置` |
| `fix` | 修复 bug | `fix: 修复 SSH 配置中的布尔值类型错误` |
| `docs` | 文档更新 | `docs: 更新 CLAUDE.md 中的部署流程` |
| `style` | 代码格式化（不影响功能） | `style: 统一配置文件缩进格式` |
| `refactor` | 代码重构 | `refactor: 重构模块导入结构` |
| `config` | 配置变更 | `config: 启用 VMware guest 工具` |
| `init` | 初始化项目或模块 | `init: 创建虚拟机配置目录结构` |
| `update` | 更新依赖或版本 | `update: 升级 NixOS 系统版本至 25.05` |
| `remove` | 删除功能或文件 | `remove: 移除未使用的配置模块` |

#### 范围 (Scope) 常见值
- `vm-nixos`: 虚拟机相关配置
- `ssh`: SSH 服务配置
- `users`: 用户管理配置
- `boot`: 启动加载器配置
- `modules`: 通用模块配置
- `home-manager`: home-manager 相关配置
- `flake`: flake.nix 配置
- `docs`: 文档文件

#### 描述 (Description) 规则
1. **使用中文**：所有描述使用简体中文
2. **动词开头**：使用动词或动词短语开头
3. **简洁明确**：不超过 50 个字符
4. **突出重点**：说明变更的主要目的和效果
5. **避免废话**：不要使用"本次"、"现在"等冗余词汇

#### 提交信息示例

**推荐的提交信息**：
```bash
git commit -m "feat(vm-nixos): 添加 EFI 启动配置和 SSH 密钥认证"
git commit -m "fix(ssh): 修复密码认证配置中的布尔值类型错误"
git commit -m "docs: 更新 CLAUDE.md 中的部署流程说明"
git commit -m "config: 启用 VMware guest 增强功能"
git commit -m "init: 创建 modolet 用户的 home-manager 配置"
```

**不推荐的提交信息**：
```bash
git commit -m "修改配置文件"           # 过于模糊
git commit -m "update files"           # 未使用中文
git commit -m "本次添加了新的功能"      # 包含冗余词汇
git commit -m "fix: fix the bug"       # 重复描述
git commit -m "feat: 添加了一些配置"    # 描述不够具体
```

#### 特殊情况处理

**多相关变更**：
当一次提交包含多个相关的变更时，使用概括性描述：
```bash
git commit -m "config(vm-nixos): 完成虚拟机基础配置部署"
```

**文档和代码同步更新**：
当同时更新代码和文档时，使用 `docs` 类型：
```bash
git commit -m "docs: 记录当前实现状态和部署流程"
```

**临时或测试性提交**：
在开发过程中，可以使用更简洁的描述，但仍需遵循基本规则：
```bash
git commit -m "test: 验证 VMware tools 安装"
```

### 3. .gitignore 配置

已配置的忽略规则：
- Nix 构建产物：`result*`
- 编辑器文件：`.vscode/`, `*.swp` 等
- 系统文件：`.DS_Store`, `Thumbs.db`
- 敏感信息：`secrets/` 目录（保留 `.gitkeep`）
- 临时文件：`*.tmp`, `*.log`
- 参考配置：`references/` 目录（仅供学习参考）

### 4. 分支策略

**当前策略**：
- 使用 `master` 分支进行开发
- 每次修改直接提交到 `master` 并推送
- 暂不使用分支开发策略

**未来可能的扩展**：
- 为重大功能开发创建特性分支
- 为不同主机配置创建独立分支
- 为版本发布创建标签

### 5. 版本控制最佳实践

**配置文件管理**：
- 所有配置文件都应纳入版本控制
- 敏感信息通过加密方式管理
- 配置变更应该原子化，确保系统可重现

**文档同步**：
- 每次结构变更时同步更新 CLAUDE.md
- 重要配置决策应记录在文档中
- 保持文档与实际配置的一致性

**协作注意事项**：
- 提交前确保配置语法正确
- 重要变更前先在测试环境验证
- 保持提交历史清晰可读