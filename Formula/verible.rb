class Verible < Formula
  desc "SystemVerilog parser, formatter, linter, and language server"
  homepage "https://github.com/chipsalliance/verible"
  version "0.0-4053-g89d4d98a"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/chipsalliance/verible/releases/download/v#{version}/verible-v#{version}-macOS.tar.gz"
      sha256 "6eb2ed4f443baed841159f3b23ebebd70d2fde789e64f6f3e2baa02ef73a0ddd"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/chipsalliance/verible/releases/download/v#{version}/verible-v#{version}-linux-static-x86_64.tar.gz"
      sha256 "1edc1f29c70d74213ed373e727183802d5a733e23f9ab9c74462f5b18b76f2c0"
    end

    on_arm do
      url "https://github.com/chipsalliance/verible/releases/download/v#{version}/verible-v#{version}-linux-static-arm64.tar.gz"
      sha256 "e6184011e93eb843fe0b5f1ecc60dcb06eec0ca05784f5caff1a17814068bca1"
    end
  end

  def install
    bin.install Dir["bin/*"]
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/verible-verilog-format --version")
    system bin/"verible-verilog-lint", "--version"
  end
end
