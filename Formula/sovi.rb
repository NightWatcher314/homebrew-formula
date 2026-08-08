class Sovi < Formula
  desc "Polished TUI for systemd and macOS launchd services"
  homepage "https://github.com/NightWatcher314/sovi"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/NightWatcher314/sovi/releases/download/v0.1.1/sovi_Darwin_arm64.tar.gz"
      sha256 "ff4b0a83dab7a09871ec29cfbba84b7fe0b2e12761a76b230d713bed67dc679b"
    end

    on_intel do
      url "https://github.com/NightWatcher314/sovi/releases/download/v0.1.1/sovi_Darwin_x86_64.tar.gz"
      sha256 "50a84e0f25b49d47b0cf7e9fc8cdfbc8051a71dce2f0d58f548fd3799657d20a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/NightWatcher314/sovi/releases/download/v0.1.1/sovi_Linux_arm64.tar.gz"
      sha256 "b7eee2801c784d6693652d0a1e448b50265c29a71ed48ade034acf947b7a38a2"
    end

    on_intel do
      url "https://github.com/NightWatcher314/sovi/releases/download/v0.1.1/sovi_Linux_x86_64.tar.gz"
      sha256 "152e5c8faef3871b980d0f4b3478568449a4531a4760ea85f75b4c45532f6db5"
    end
  end

  def install
    bin.install "sovi"
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/sovi --help")
  end
end
