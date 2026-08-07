class Sysz < Formula
  desc "Fzf terminal UI for systemd and macOS launchd"
  homepage "https://github.com/NightWatcher314/sysz"
  url "https://github.com/NightWatcher314/sysz/releases/download/2.1.0/sysz"
  sha256 "85ee2a4c106e1e241525a3b37d7e6a8da7d267aefc9db9e4f7fd708f1bd2d524"
  license "Unlicense"

  depends_on "bash"
  depends_on "fzf"

  def install
    inreplace "sysz", "#!/usr/bin/env bash", "#!#{formula_opt_bin("bash")}/bash"
    bin.install "sysz"
  end

  test do
    assert_match "sysz 2.1.0", shell_output("#{bin}/sysz --version")
  end
end
