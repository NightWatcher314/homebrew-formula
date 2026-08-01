class Dockgectl < Formula
  desc "CLI for Dockge Socket.IO automation"
  homepage "https://github.com/NightWatcher314/dockgectl"
  url "https://github.com/NightWatcher314/dockgectl/archive/refs/tags/v0.2.4.tar.gz"
  sha256 "1b18516041145421a28a9f4dc471b515f1e700328b22f604c9575c71780d39d6"
  license "MIT"

  bottle do
    root_url "https://github.com/NightWatcher314/homebrew-formula/releases/download/dockgectl-0.2.4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "1434d84ae1fd3d7c8f99143d888e359efa6c4e07fbe7c38859cd9977d2540abd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "0d14ed65debcfbbdd208c0f6b639da9ef2f51674bfd42e2643a71221ea60dca3"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "31522df1c88dd77ec95cea6d2f2bf2e14eb1b07b07fea9b78993512585f8b4bd"
  end

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
