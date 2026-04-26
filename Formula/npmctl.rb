class Npmctl < Formula
  desc "CLI for Nginx Proxy Manager API automation"
  homepage "https://github.com/NightWatcher314/npmctl"
  url "https://github.com/NightWatcher314/npmctl/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "da16d390b1f9e0a0c4bf3844e68c075a9cf1f00eef097cf83325b347d934408b"
  license "MIT"
  revision 1

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
