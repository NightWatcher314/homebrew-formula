class Yabai < Formula
  desc "Tiling window manager for macOS based on binary space partitioning"
  homepage "https://github.com/NightWatcher314/yabai"
  url "https://github.com/NightWatcher314/yabai/releases/download/v7.1.30/yabai-v7.1.30.tar.gz"
  sha256 "0f6459d612a8afc136a301f491da329ce454fe8b44b5137b9fe98584200bed38"
  license "MIT"

  depends_on :macos

  def install
    bin.install "bin/yabai"
    man1.install "doc/yabai.1"
    (pkgshare/"examples").install "examples/yabairc", "examples/skhdrc"
  end

  def caveats
    <<~EOS
      This release is built from NightWatcher314/yabai and ad-hoc signed.
      It is not Apple Developer ID signed or notarized.

      Grant Accessibility permission, then start yabai's own launchd service:
        yabai --start-service

      When using the scripting addition, update /private/etc/sudoers.d/yabai
      with the installed binary's SHA256 after every upgrade, before restarting.
      See the tap README for the release and upgrade procedure.
    EOS
  end

  test do
    assert_match "yabai-v#{version}", shell_output("#{bin}/yabai --version")
  end
end
