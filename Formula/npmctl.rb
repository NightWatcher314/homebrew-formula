class Npmctl < Formula
  desc "CLI for Nginx Proxy Manager API automation"
  homepage "https://github.com/NightWatcher314/npmctl"
  url "https://github.com/NightWatcher314/npmctl/archive/refs/tags/v0.5.3.tar.gz"
  sha256 "68d8d577e55660e0beb985f18b0ef4b0bb98144c362008daf3c811da3fed32bc"
  license "MIT"

  bottle do
    root_url "https://github.com/NightWatcher314/homebrew-formula/releases/download/npmctl-0.5.3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "41c706a8433667c7883b0f864769250057a1d7463794dce52845bdedf5785314"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "6fa021f1d3e4760b94bda5205bb2ce7f3b8a127feadfe5b46b886627414214b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "20360318b47751be362a515bbd0f62d446dcb72f28ec6bbc794d0f5ee54b7c1c"
  end

  depends_on "uv" => :build
  depends_on "python@3.13"

  def install
    prefix.install "README.md", "LICENSE"
    libexec.install "pyproject.toml", "uv.lock", "src"
    libexec.install_symlink prefix/"README.md"
    libexec.install_symlink prefix/"LICENSE"

    ENV["UV_NO_CONFIG"] = "1"
    ENV["UV_PROJECT_ENVIRONMENT"] = libexec/"venv"

    system "uv", "sync",
           "--project", libexec,
           "--locked",
           "--no-dev",
           "--no-editable",
           "--python", formula_opt_bin("python@3.13")/"python3.13"

    bin.install_symlink libexec/"venv/bin/npmctl"
  end

  test do
    output = shell_output("#{bin}/npmctl --help")
    assert_match "Nginx Proxy Manager CLI", output
  end
end
