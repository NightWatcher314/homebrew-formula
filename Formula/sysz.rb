class Sysz < Formula
  desc "Fzf terminal UI for systemd and macOS launchd"
  homepage "https://github.com/NightWatcher314/sysz"
  url "https://github.com/NightWatcher314/sysz/releases/download/2.0.0/sysz"
  sha256 "70caf788ee843d8df136a34e3d88a4cc2cdcf5f3c6cda4d73d9f2a21315564ce"
  license "Unlicense"

  depends_on "bash"
  depends_on "fzf"

  def install
    inreplace "sysz", "#!/usr/bin/env bash", "#!#{formula_opt_bin("bash")}/bash"
    bin.install "sysz"
  end

  test do
    assert_match "sysz 2.0.0", shell_output("#{bin}/sysz --version")
  end
end
