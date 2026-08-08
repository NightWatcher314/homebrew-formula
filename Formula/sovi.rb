class Sovi < Formula
  desc "Polished TUI for systemd and macOS launchd services"
  homepage "https://github.com/NightWatcher314/sovi"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/NightWatcher314/sovi/releases/download/v0.1.2/sovi_Darwin_arm64.tar.gz"
      sha256 "61750553688d26b9916594f24b0587cc3d4da5eb488014b1931c8d8c8f3dd55b"
    end

    on_intel do
      url "https://github.com/NightWatcher314/sovi/releases/download/v0.1.2/sovi_Darwin_x86_64.tar.gz"
      sha256 "be79d0fe0182b43577e3c9ac3975b6d6da9e2b73a9b866a1896c0e2ade595732"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/NightWatcher314/sovi/releases/download/v0.1.2/sovi_Linux_arm64.tar.gz"
      sha256 "a4321bc9d3d65d8341e3bfc31b4cc09811e6f8cfb6dbf091e57770d0af6751a1"
    end

    on_intel do
      url "https://github.com/NightWatcher314/sovi/releases/download/v0.1.2/sovi_Linux_x86_64.tar.gz"
      sha256 "f4d116bec7fc0c069cd25dd45627c47a6ec6596738ac629999d003feb0d3b630"
    end
  end

  def install
    bin.install "sovi"
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/sovi --help")
  end
end
