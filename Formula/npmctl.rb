class Npmctl < Formula
  desc "CLI for Nginx Proxy Manager API automation"
  homepage "https://github.com/NightWatcher314/npmctl"
  url "https://github.com/NightWatcher314/npmctl/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "27be09062e1c7135691acb3a7ddd68f255215d443cb2ed509096f4d287964ed8"
  license "MIT"

  bottle do
    root_url "https://github.com/NightWatcher314/homebrew-formula/releases/download/npmctl-0.5.2"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "881c770341b57bced39846b4b8b9b9ac304a0aae53786c4a7114a56e7121c301"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "2a97d44f0bf1527f6b40f94fd1099fafe0817990f7ea0327fe1e179598b9bbee"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "7a0b49c529d5e628c18bdf1496010b797a04fa60724269c9ebea9d17d1d3ab7c"
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
