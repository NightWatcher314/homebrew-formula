class Dockgectl < Formula
  desc "CLI for Dockge Socket.IO automation"
  homepage "https://github.com/NightWatcher314/dockgectl"
  url "https://github.com/NightWatcher314/dockgectl/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "7c51215a8e2c76376ac9dfb2e647c68f1313bc9d8a88fb8368486d112be51f59"
  license "MIT"

  depends_on "python@3.13"
  depends_on "uv"

  def install
    prefix.install "README.md", "README-zh.md", "LICENSE"
    libexec.install "pyproject.toml", "uv.lock", "src"
    libexec.install_symlink prefix/"README.md"
    libexec.install_symlink prefix/"README-zh.md"
    libexec.install_symlink prefix/"LICENSE"

    (bin/"dockgectl").write <<~SH
      #!/usr/bin/env bash
      set -euo pipefail

      ROOT="#{opt_libexec}"
      DATA="#{var}/dockgectl"
      CACHE="#{var}/cache/dockgectl/uv"
      PYTHON="#{Formula["python@3.13"].opt_bin}/python3.13"

      mkdir -p "$DATA" "$CACHE"

      export UV_CACHE_DIR="$CACHE"
      export UV_PROJECT_ENVIRONMENT="$DATA/.venv"

      exec "#{Formula["uv"].opt_bin}/uv" run --directory "$ROOT" --locked --python "$PYTHON" dockgectl "$@"
    SH
    chmod 0755, bin/"dockgectl"
  end

  test do
    output = shell_output("#{bin}/dockgectl --help")
    assert_match "Dockge CLI", output
  end
end
