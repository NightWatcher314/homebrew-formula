class Sovi < Formula
  desc "Polished TUI for systemd and macOS launchd services"
  homepage "https://github.com/NightWatcher314/sovi"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/NightWatcher314/sovi/releases/download/v0.4.0/sovi_Darwin_arm64.tar.gz"
      sha256 "57f64c298d8510afed45dea3bbb13d1015525d506e57af0ae06665bdc746f4e1"
    end

    on_intel do
      url "https://github.com/NightWatcher314/sovi/releases/download/v0.4.0/sovi_Darwin_x86_64.tar.gz"
      sha256 "207668d154fe5c82f610f8cb68b1fc6f491151ee0705b2471d560dad4a9f5cb0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/NightWatcher314/sovi/releases/download/v0.4.0/sovi_Linux_arm64.tar.gz"
      sha256 "e8e0786da08685a26a97faa8f8d75e813fb1602eacea4d5d0abdb557488500cf"
    end

    on_intel do
      url "https://github.com/NightWatcher314/sovi/releases/download/v0.4.0/sovi_Linux_x86_64.tar.gz"
      sha256 "7d3e97563c0939b438e5f45583b41eb5b237449cc088282f92f29aa22b27b63f"
    end
  end

  def install
    bin.install "sovi"
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/sovi --help")
  end
end
