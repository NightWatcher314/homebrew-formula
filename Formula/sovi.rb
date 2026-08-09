class Sovi < Formula
  desc "Polished TUI for systemd and macOS launchd services"
  homepage "https://github.com/NightWatcher314/sovi"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/NightWatcher314/sovi/releases/download/v0.2.0/sovi_Darwin_arm64.tar.gz"
      sha256 "8d49773a7056af2cf68d7827050592ca1372a895486b78c114a08af3787a8641"
    end

    on_intel do
      url "https://github.com/NightWatcher314/sovi/releases/download/v0.2.0/sovi_Darwin_x86_64.tar.gz"
      sha256 "4e7003a7e896353aa6e6187657ad70698da9deadd7a8c6d8bd73a53188487e8d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/NightWatcher314/sovi/releases/download/v0.2.0/sovi_Linux_arm64.tar.gz"
      sha256 "3f5d130ee61f879f8b6bf9c3aacbc65d61110b7d588f7c8ae5b366e540524f61"
    end

    on_intel do
      url "https://github.com/NightWatcher314/sovi/releases/download/v0.2.0/sovi_Linux_x86_64.tar.gz"
      sha256 "16989f3ca12271ce9503d2d5a4ccf203478f700d2c30d59a65f75d52bd7f3160"
    end
  end

  def install
    bin.install "sovi"
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/sovi --help")
  end
end
