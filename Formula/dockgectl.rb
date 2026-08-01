class Dockgectl < Formula
  desc "CLI for Dockge Socket.IO automation"
  homepage "https://github.com/NightWatcher314/dockgectl"
  url "https://github.com/NightWatcher314/dockgectl/archive/refs/tags/v0.2.4.tar.gz"
  sha256 "1b18516041145421a28a9f4dc471b515f1e700328b22f604c9575c71780d39d6"
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
           "--python", formula_opt_bin("python@3.13")/"python3.13"

    bin.install_symlink libexec/"venv/bin/dockgectl"
  end

  test do
    output = shell_output("#{bin}/dockgectl --help")
    assert_match "Dockge CLI", output
  end
end
