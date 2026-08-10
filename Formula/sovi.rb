class Sovi < Formula
  desc "Polished TUI for systemd and macOS launchd services"
  homepage "https://github.com/NightWatcher314/sovi"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/NightWatcher314/sovi/releases/download/v0.3.0/sovi_Darwin_arm64.tar.gz"
      sha256 "fb409d144fda573672611fb70400f68a443040dab7d03f2abce628ed1058d7a6"
    end

    on_intel do
      url "https://github.com/NightWatcher314/sovi/releases/download/v0.3.0/sovi_Darwin_x86_64.tar.gz"
      sha256 "24a82fe90d21b80117aa50e24b5c84116a2f5b4430487f4852e7285933add7b9"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/NightWatcher314/sovi/releases/download/v0.3.0/sovi_Linux_arm64.tar.gz"
      sha256 "61e1788148b7fb2dddf150c49bf762ffecfec6ce730bca63ddff71050ca90f0e"
    end

    on_intel do
      url "https://github.com/NightWatcher314/sovi/releases/download/v0.3.0/sovi_Linux_x86_64.tar.gz"
      sha256 "213bdfd7beb3c3ab3b11d39e5f5085629d3c74d8a5f503e0acaff19151030f02"
    end
  end

  def install
    bin.install "sovi"
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/sovi --help")
  end
end
