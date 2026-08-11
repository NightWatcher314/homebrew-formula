class Sovi < Formula
  desc "Polished TUI for systemd and macOS launchd services"
  homepage "https://github.com/NightWatcher314/sovi"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/NightWatcher314/sovi/releases/download/v0.5.0/sovi_Darwin_arm64.tar.gz"
      sha256 "302d5a3f888d95dcd3ebcded0195028e1eaa2a638f62ebc373ff8a8b414442d5"
    end

    on_intel do
      url "https://github.com/NightWatcher314/sovi/releases/download/v0.5.0/sovi_Darwin_x86_64.tar.gz"
      sha256 "f4255e0bc317f0ab496b3217010de0801e33c4ee1a0bd9f2c0342ac306213e68"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/NightWatcher314/sovi/releases/download/v0.5.0/sovi_Linux_arm64.tar.gz"
      sha256 "8af1cdf5d5cc968a686db404272385c1e0c155694533e5c83613cd59b6105f07"
    end

    on_intel do
      url "https://github.com/NightWatcher314/sovi/releases/download/v0.5.0/sovi_Linux_x86_64.tar.gz"
      sha256 "541f303af7eb7458eefdef22489ba5b9f2b63ca3e47155611ac9b3bba87eaa10"
    end
  end

  def install
    bin.install "sovi"
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/sovi --help")
  end
end
