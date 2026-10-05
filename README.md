# NightWatcher314's Homebrew Formula

用于放一些我自己打包的 Homebrew 配方。

## 使用方式

```bash
brew tap NightWatcher314/homebrew-formula
```

## 目前包含

当前包含 9 个 formula：

- [dockgectl](https://github.com/NightWatcher314/dockgectl) — Dockge Socket.IO 自动化 CLI（Python，提供 bottle）
- [npmctl](https://github.com/NightWatcher314/npmctl) — Nginx Proxy Manager API 自动化 CLI（Python，提供 bottle）
- [SbarLua](https://github.com/FelixKratz/SbarLua) — SketchyBar 的 Lua C 模块
- [sovi](https://github.com/NightWatcher314/sovi) — Go + Bubble Tea 编写的 systemd/launchd 服务管理 TUI
- [sysz](https://github.com/NightWatcher314/sysz) — 统一管理 Linux systemd 与 macOS launchd 服务的 fzf TUI
- [zotero-pdf2zh-next](https://github.com/NightWatcher314/zotero-pdf2zh-next) — 精简版 Zotero pdf2zh_next 本地服务器（Python，提供 bottle）
- [zotero-pdf2zh](https://github.com/guaguastandup/zotero-pdf2zh) — 当前版本 <!-- formula-version:zotero-pdf2zh --> v4.1.7；Zotero PDF → ZH 本地服务器旧版配方（Python，安装期用 uv 创建固定 venv）
- [verible](https://github.com/chipsalliance/verible) — SystemVerilog formatter/linter/language server（二进制包，支持 Linux x86_64/arm64 与 macOS arm64）
- [yabai](https://github.com/NightWatcher314/yabai) — 同步 Christian-SC26/yabai 后自行构建的 macOS 通用二进制，使用 ad-hoc 签名

### yabai 发布与升级

`yabai` 配方从自己的 fork release 安装预编译包，不再应用独立的 RunLoop 补丁。
v7.1.32 对应源码 `c547f46`，保留 v7.1.31（`8afe280`）恢复 macOS 27.0 的
三个 scripting-addition 接口；27.1/27.2 保持禁用，插件版本为 2.1.36。
在 27.0 (26A428) 上，能力握手为 `0x7f`；临时桌面重排、普通跨 App 激活、插件内
同 App 两窗口聚焦往返通过，原布局和聚焦设置已还原。跨屏搬整个桌面尚未实测。
本包由 Apple clang 21.0.0 在 macOS 27.0 上构建，包含 `x86_64` 和 `arm64`。
从 v7.1.32 起使用长期自签 Code Signing 证书和固定 designated requirement，
签名标识为 `com.asmvik.yabai`，证书 SHA1 为 `E9E284C4A5B5337E77AEEBE7AE9B7A5B9C7BABC0`。
这不是 Apple Developer ID 签名或 Apple 公证。

发布新版本时：保留本机钥匙串中的原始 `yabai-cert` 证书及私钥，不重新创建。
执行 fork 的 `bash scripts/release.sh`，脚本固定证书指纹；缺少原身份时直接停止，
不会退回 ad-hoc 签名。发布生成的归档和 SHA256，更新配方 URL 与 SHA256。
公开包已签好，Homebrew 安装时不访问用户钥匙串；私钥不进入 Git、CI 或发布包。
已发布资产不原地替换；
同版本重新构建应使用新的 release 标识及 Formula revision。

```sh
brew install nightwatcher314/formula/yabai
# 后续升级
brew upgrade nightwatcher314/formula/yabai
```

首次从手工安装迁移时，先备份并移走与 Homebrew 链接冲突的旧可执行文件。
使用 yabai 自己的 launchd 服务，不运行 `brew services start yabai`。每次升级前备份
二进制、LaunchAgent、专用 sudoers 和已安装的 scripting addition；升级后用
`sudo visudo -f /private/etc/sudoers.d/yabai` 更新 `--load-sa` 授权中的二进制 SHA256，
运行 `sudo visudo -cf /private/etc/sudoers.d/yabai` 校验，再重启 yabai。
主程序升级不保证已安装的 scripting addition 更新；需要时单独备份、卸载并重新加载，
该步骤可能重启 Dock。最终检查辅助功能权限、插件状态、真实窗口移动及多屏 Space 切换。
权限失效需在系统设置中重新授权；不能只凭 `--version` 宣称升级完成。

长期启动与授权统一使用固定路径 `/opt/homebrew/opt/yabai/bin/yabai`（Intel 使用
`/usr/local/opt/yabai/bin/yabai`）。LaunchAgent 的 `ProgramArguments[0]` 保持这个路径，
不要随升级改成带版本号的 Cellar 路径。从旧 ad-hoc 身份迁移需授权一次；以后正常升级
保留同一证书、签名标识与路径即可继承身份。换证书或系统重置权限可能需要重新授权。
删除旧权限时按路径区分同名条目；证书指纹、代码签名规则与运行进程都要实际核验。

`dockgectl`、`npmctl` 提供 macOS Apple Silicon（Sonoma、Tahoe）和 Linux x86_64 bottle；`zotero-pdf2zh-next` 的构建目标覆盖 Homebrew 当前 macOS Tier 1：Apple Silicon Sequoia 15、Tahoe 26、Golden Gate 27，以及 Linux x86_64，保留已有历史资产。其他平台回退到源码构建：使用公开 PyPI 锁文件创建固定 venv，运行时直接执行 `libexec/venv` 里的入口脚本，不读取用户的 uv 全局镜像配置。

CI 在启动 Homebrew runner 前按变更选择平台：PR 与合并基点比较，push 比较完整 before/after 范围。仅变更 `zotero-pdf2zh-next` 配方时使用上述四个目标；混合变更同时保留其他配方的旧平台检查；不涉及 PDF2Zh 的变更保留原矩阵。配方删除也计入选择，重命名按删除加新增处理。离线验证：`python3 -m unittest discover -s .github/scripts -p "test_matrix_test.py"`。


PDF2Zh 使用 `macos-15`、`macos-26` 和 `xcode-27` ARM64 runner；`xcode-27` 当前为公开预览，GitHub 已于 2026-09-10 将其系统升级为 macOS 27。CI 同时断言 `uname -m` 和 macOS 主版本，防止工具链标签变化导致覆盖失真。参考 [Homebrew 支持范围](https://docs.brew.sh/Support-Tiers) 与 [GitHub runner 公告](https://github.blog/changelog/2026-09-10-xcode-27-runner-image-now-runs-on-macos-27/)。

可手动验证当前版本，无需修改应用版本或 Formula revision：

```bash
gh workflow run tests.yml --repo NightWatcher314/homebrew-formula --ref main
```

该入口固定在上述四个目标重新构建、安装并测试 PDF2Zh，要求实际生成 bottle tarball 和 JSON 元数据，上传 artifacts；不会自动发布或替换现有 bottle。预览 runner 的失败也会使验证失败，不以跳过代替支持。
