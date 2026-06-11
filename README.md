# NightWatcher314's Homebrew Formula

用于放一些我自己打包的 Homebrew 配方。

## 使用方式

```bash
brew tap NightWatcher314/homebrew-formula
```

## 目前包含

当前包含 5 个 formula：

- [dockgectl](https://github.com/NightWatcher314/dockgectl) — Dockge Socket.IO 自动化 CLI（Python，安装期用 uv 创建固定 venv）
- [npmctl](https://github.com/NightWatcher314/npmctl) — Nginx Proxy Manager API 自动化 CLI（Python，安装期用 uv 创建固定 venv）
- [zotero-pdf2zh-next](https://github.com/NightWatcher314/zotero-pdf2zh-next) — 精简版 Zotero pdf2zh_next 本地服务器（Python，安装期用 uv 创建固定 venv）
- [zotero-pdf2zh](https://github.com/guaguastandup/zotero-pdf2zh) — Zotero PDF → ZH 本地服务器旧版配方（Python，安装期用 uv 创建固定 venv）
- [verible](https://github.com/chipsalliance/verible) — SystemVerilog formatter/linter/language server（二进制包，支持 Linux x86_64/arm64 与 macOS arm64）

Python 类 formula 尽量在 Homebrew 安装阶段完成依赖解析和虚拟环境创建，运行时直接执行 `libexec/venv` 里的入口脚本，避免把用户本机的 uv 全局配置作为隐式运行时输入。
