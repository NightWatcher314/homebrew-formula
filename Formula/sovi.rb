class Sovi < Formula
  desc "Polished TUI for systemd and macOS launchd services"
  homepage "https://github.com/NightWatcher314/sovi"
  version "0.1.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/NightWatcher314/sovi/releases/download/v#{version}/sovi_Darwin_arm64.tar.gz"
      sha256 "778cfcd085db1b90988dcb45512b69ff0336435539bd31cc828e40f05cc8526d"
    end

    on_intel do
      url "https://github.com/NightWatcher314/sovi/releases/download/v#{version}/sovi_Darwin_x86_64.tar.gz"
      sha256 "7cceac1df52f3e8c647e8ea1440c9d0665a40f5d6a17523b33227fbfff2b6b00"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/NightWatcher314/sovi/releases/download/v#{version}/sovi_Linux_arm64.tar.gz"
      sha256 "3725cb8950dd39ce9160079986143c168d525fb82714628139f38d1c19c20fd4"
    end

    on_intel do
      url "https://github.com/NightWatcher314/sovi/releases/download/v#{version}/sovi_Linux_x86_64.tar.gz"
      sha256 "1addbeb229783463b0ee3273a2e6df357cf16cf847948c2f7bc7b4fbca746f5e"
    end
  end

  def install
    bin.install "sovi"
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/sovi --help")
  end
end
