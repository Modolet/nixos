# Repository Guidelines

## 项目结构与模块组织
- `flake.nix`/`flake.lock`：Flake 入口与锁定版本。
- `hosts/`：主机级 NixOS 配置（如 `vmware/`、`togo/`）。
- `system/`：系统模块拆分（`core/`、`desktop/`、`network/`、`programs/`）。
- `home/`：home-manager 模块（`desktop/`、`editor/`、`shell/`、`style/`、`ai/`）。
- `pkgs/` 与 `pkgs/overlays/`：自定义包与覆盖。
- `devshells/`：开发环境定义（`clang`、`rust`、`qt5`、`win-clang`）。
- `lib/`、`docs/`、`tools/`：通用函数、文档与脚本。

## 构建、测试与开发命令
- `nix develop .#clang`：进入指定 devshell（也可用 `.#rust`、`.#qt5`）。
- `nix flake check`：执行基础校验，建议在提交前运行。
- `sudo nixos-rebuild build --flake .#vmware`：构建指定主机配置。
- `sudo nixos-rebuild switch --flake .#togo`：应用配置到本机。

## 编码风格与命名规范
- Nix 文件保持 2 空格缩进与现有 `{ ... }:` 结构风格。
- 文件/目录以小写与短横线命名（如 `hardware-configuration.nix`）。
- 未见固定格式化工具，请优先保持相邻文件风格一致。

## 测试指南
- 仓库未包含专用测试框架，`nix flake check` 与 `nixos-rebuild build` 是主要验证方式。
- 修改主机相关配置时，优先对对应 `hosts/<name>` 执行构建验证。

## 提交与 PR 规范
- 提交信息遵循 Conventional Commits，中文描述，例如：`fix: 修复 win-clang 工具链封装`。
- PR 描述需说明影响主机、关键变更点与验证命令（如 `nix flake check`）。

## 配置与安全提示
- 主机专属配置放在 `hosts/<name>`，通用模块放入 `system/` 或 `home/`。
- 新增第三方输入请更新 `flake.lock`，并说明来源与用途。
