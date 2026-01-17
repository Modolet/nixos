# 壁纸管理（swww + 主题联动）

## 添加壁纸

- 默认壁纸来源：`pkgs/wallpapers.nix`（通过 `fetchurl` 拉入 Nix store）。
- 添加新壁纸：编辑 `pkgs/wallpapers.nix` 增加条目，然后 `nix flake check`/`home-manager switch` 重新构建。
- 如需自定义目录：在 Home Manager 中设置 `modules.wallpaper.wallpaperDir` 指向 Nix 管理的路径（例如 `pkgs.linkFarm` 或自建 derivation）。
- 需要缩小列表：配置 `modules.wallpaper.wallpaperList` 仅暴露部分文件名。

## 常用命令

- `wallpaper list` 列出壁纸（当前项带 `*`）
- `wallpaper set <name>` 切换壁纸
- `wallpaper next` / `wallpaper prev` 轮播
- `wallpaper mode <plain|recolor|monet>` 切换模式
- `wallpaper current` 查看当前状态
- `wallpaper apply --blur` 强制应用当前壁纸的模糊版本（不改状态）

## 模式说明

- `plain`：原图直接设置。
- `recolor`：使用当前 Stylix base16 调色板对壁纸重新上色，结果缓存到 `XDG_CACHE_HOME/wallpaper/recolor`。主题切换（home-manager 激活）后会自动重上色并更新。
- `monet`：基于壁纸生成 Material You/Monet 配色（由 `matugen` 在 Nix 构建期生成 base16 方案），切换壁纸会同步切换到对应 `monet-*` 主题 specialisation。

## 状态与缓存

- 状态：`XDG_STATE_HOME/wallpaper/state.json`
- Monet 映射：`XDG_STATE_HOME/wallpaper/monet-map.json`
- Recolor 缓存：`XDG_CACHE_HOME/wallpaper/recolor/`
- Blur 缓存：`XDG_CACHE_HOME/wallpaper/blur/`

## 快捷键示例（xremap）

在 `home/desktop/niri/xremap.nix` 的 `commonRemap` 或 `niriRemap` 增加：

```nix
"Super-Shift-w" = launchCmd "wallpaper next";
"Super-Shift-r" = launchCmd "wallpaper mode recolor";
```

## 清理/回滚

- 回滚配置：`home-manager switch --rollback` 或 `theme-switch default`
- 清理运行时状态与缓存：

```bash
rm -rf "$XDG_STATE_HOME/wallpaper" "$XDG_CACHE_HOME/wallpaper"
```

清理后可执行 `wallpaper apply` 或重新登录以恢复默认壁纸。
