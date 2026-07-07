class Dockgectl < Formula
  desc "CLI for Dockge Socket.IO automation"
  homepage "https://github.com/NightWatcher314/dockgectl"
  url "https://github.com/NightWatcher314/dockgectl/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "e910d96ac6a2727f985f6eb28274f72524d35bcd881ee56196bf4994cb4bf4ff"
  license "MIT"

  depends_on "uv" => :build
  depends_on "python@3.13"

  def install
    prefix.install "README.md", "README-zh.md", "LICENSE"
    libexec.install "pyproject.toml", "uv.lock", "src"
    libexec.install_symlink prefix/"README.md"
    libexec.install_symlink prefix/"README-zh.md"
    libexec.install_symlink prefix/"LICENSE"

    ENV["UV_NO_CONFIG"] = "1"
    ENV["UV_PROJECT_ENVIRONMENT"] = libexec/"venv"

    system "uv", "sync",
           "--project", libexec,
           "--locked",
           "--no-dev",
           "--no-editable",
           "--python", Formula["python@3.13"].opt_bin/"python3.13"

    bin.install_symlink libexec/"venv/bin/dockgectl"
  end

  test do
    output = shell_output("#{bin}/dockgectl --help")
    assert_match "Dockge CLI", output
  end
end
