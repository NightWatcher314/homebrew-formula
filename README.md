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
- [zotero-pdf2zh](https://github.com/guaguastandup/zotero-pdf2zh) — 当前版本 <!-- formula-version:zotero-pdf2zh --> v4.1.7；Zotero PDF → ZH 本地服务器旧版配方（Python，安装期用 uv 创建固定 venv）
- [verible](https://github.com/chipsalliance/verible) — SystemVerilog formatter/linter/language server（二进制包，支持 Linux x86_64/arm64 与 macOS arm64）

`dockgectl`、`npmctl` 提供 macOS Apple Silicon（Sonoma、Tahoe）和 Linux x86_64 bottle；`zotero-pdf2zh-next` 的构建目标覆盖 Homebrew 当前 macOS Tier 1：Apple Silicon Sequoia 15、Tahoe 26、Golden Gate 27，以及 Linux x86_64，保留已有历史资产。其他平台回退到源码构建：使用公开 PyPI 锁文件创建固定 venv，运行时直接执行 `libexec/venv` 里的入口脚本，不读取用户的 uv 全局镜像配置。

CI 在启动 Homebrew runner 前按变更选择平台：PR 与合并基点比较，push 比较完整 before/after 范围。仅变更 `zotero-pdf2zh-next` 配方时使用上述四个目标；混合变更同时保留其他配方的旧平台检查；不涉及 PDF2Zh 的变更保留原矩阵。配方删除也计入选择，重命名按删除加新增处理。离线验证：`python3 -m unittest discover -s .github/scripts -p "test_matrix_test.py"`。


PDF2Zh 使用 `macos-15`、`macos-26` 和 `xcode-27` ARM64 runner；`xcode-27` 当前为公开预览，GitHub 已于 2026-09-10 将其系统升级为 macOS 27。CI 同时断言 `uname -m` 和 macOS 主版本，防止工具链标签变化导致覆盖失真。参考 [Homebrew 支持范围](https://docs.brew.sh/Support-Tiers) 与 [GitHub runner 公告](https://github.blog/changelog/2026-09-10-xcode-27-runner-image-now-runs-on-macos-27/)。

可手动验证当前版本，无需修改应用版本或 Formula revision：

```bash
gh workflow run tests.yml --repo NightWatcher314/homebrew-formula --ref main
```

该入口固定在上述四个目标重新构建、安装并测试 PDF2Zh，要求实际生成 bottle tarball 和 JSON 元数据，上传 artifacts；不会自动发布或替换现有 bottle。预览 runner 的失败也会使验证失败，不以跳过代替支持。
