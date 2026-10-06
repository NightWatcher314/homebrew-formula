class Yabai < Formula
  desc "Tiling window manager for macOS based on binary space partitioning"
  homepage "https://github.com/NightWatcher314/yabai"
  url "https://github.com/NightWatcher314/yabai/releases/download/v7.1.32/yabai-v7.1.32.tar.gz"
  sha256 "3a2badcf9941e96446473c477ec0f82bd87f60860ea530995510df3f0580d554"
  license "MIT"
  revision 1

  depends_on :macos

  def install
    bin.install "bin/yabai"
    man1.install "doc/yabai.1"
    (pkgshare/"examples").install "examples/yabairc", "examples/skhdrc"
  end

  post_install_steps do
    copy "yabai", "yabai/yabai.new", source_base: :bin, target_base: :var
    move "yabai/yabai.new", "yabai/yabai", source_base: :var, target_base: :var, overwrite: true
  end

  def caveats
    <<~EOS
      This release uses NightWatcher314's persistent self-signed Code Signing identity.
      It is not Apple Developer ID signed or notarized.

      Use this fixed path for launchd and Accessibility authorization:
        #{var}/yabai/yabai

      Authorize the new identity once, then start yabai's own launchd service:
        #{var}/yabai/yabai --install-service
        #{var}/yabai/yabai --start-service

      When using the scripting addition, update /private/etc/sudoers.d/yabai
      with the installed binary's SHA256 after every upgrade, before restarting.
      See the tap README for the release and upgrade procedure.
    EOS
  end

  test do
    assert_match "yabai-v#{version}", shell_output("#{bin}/yabai --version")
    assert_predicate var/"yabai/yabai", :file?
    refute_predicate var/"yabai/yabai", :symlink?
    assert_equal (bin/"yabai").sha256, (var/"yabai/yabai").sha256
    system "/usr/bin/codesign", "--verify", "--strict", "-R",
           '=identifier "com.asmvik.yabai" and certificate leaf = H"E9E284C4A5B5337E77AEEBE7AE9B7A5B9C7BABC0"',
           bin/"yabai"
  end
end
