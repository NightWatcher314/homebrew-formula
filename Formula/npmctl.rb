class Npmctl < Formula
  desc "CLI for Nginx Proxy Manager API automation"
  homepage "https://github.com/NightWatcher314/npmctl"
  url "https://github.com/NightWatcher314/npmctl/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "f4a0841fa45422864d865745f80288afd36b0e1e307d587da85d53036b2f07dc"
  license "MIT"

  depends_on "python@3.13"
  depends_on "uv"

  def install
    prefix.install "README.md", "LICENSE"
    libexec.install "pyproject.toml", "uv.lock", "src"
    libexec.install_symlink prefix/"README.md"
    libexec.install_symlink prefix/"LICENSE"

    (bin/"npmctl").write <<~SH
      #!/usr/bin/env bash
      set -euo pipefail

      ROOT="#{opt_libexec}"
      DATA="#{var}/npmctl"
      CACHE="#{var}/cache/npmctl/uv"
      PYTHON="#{Formula["python@3.13"].opt_bin}/python3.13"

      mkdir -p "$DATA" "$CACHE"

      export UV_CACHE_DIR="$CACHE"
      export UV_PROJECT_ENVIRONMENT="$DATA/.venv"

      exec "#{Formula["uv"].opt_bin}/uv" run --directory "$ROOT" --locked --python "$PYTHON" npmctl "$@"
    SH
    chmod 0755, bin/"npmctl"
  end

  test do
    output = shell_output("#{bin}/npmctl --help")
    assert_match "Nginx Proxy Manager CLI", output
  end
end
