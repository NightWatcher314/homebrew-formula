# NightWatcher314's Homebrew Formula

用于放一些我自己打包的 Homebrew 配方。

## 使用方式

```bash
brew tap NightWatcher314/homebrew-formula
```

## 目前包含

当前包含 8 个 formula：

- [dockgectl](https://github.com/NightWatcher314/dockgectl) — Dockge Socket.IO 自动化 CLI（Python，提供 bottle）
- [npmctl](https://github.com/NightWatcher314/npmctl) — Nginx Proxy Manager API 自动化 CLI（Python，提供 bottle）
- [SbarLua](https://github.com/FelixKratz/SbarLua) — SketchyBar 的 Lua C 模块
- [sovi](https://github.com/NightWatcher314/sovi) — Go + Bubble Tea 编写的 systemd/launchd 服务管理 TUI
- [sysz](https://github.com/NightWatcher314/sysz) — 统一管理 Linux systemd 与 macOS launchd 服务的 fzf TUI
- [zotero-pdf2zh-next](https://github.com/NightWatcher314/zotero-pdf2zh-next) — 精简版 Zotero pdf2zh_next 本地服务器（Python，提供 bottle）
- [zotero-pdf2zh](https://github.com/guaguastandup/zotero-pdf2zh) — 当前版本 <!-- formula-version:zotero-pdf2zh --> v4.1.1；Zotero PDF → ZH 本地服务器旧版配方（Python，安装期用 uv 创建固定 venv）
- [verible](https://github.com/chipsalliance/verible) — SystemVerilog formatter/linter/language server（二进制包，支持 Linux x86_64/arm64 与 macOS arm64）

`dockgectl`、`npmctl`、`zotero-pdf2zh-next` 当前提供 macOS Apple Silicon（Sonoma、Tahoe）和 Linux x86_64 bottle。其他平台回退到源码构建：使用公开 PyPI 锁文件创建固定 venv，运行时直接执行 `libexec/venv` 里的入口脚本，不读取用户的 uv 全局镜像配置。
