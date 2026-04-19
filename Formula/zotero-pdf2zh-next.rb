class ZoteroPdf2zhNext < Formula
  desc "Minimal Zotero pdf2zh_next local server"
  homepage "https://github.com/NightWatcher314/zotero-pdf2zh-next"
  url "https://github.com/NightWatcher314/zotero-pdf2zh-next/archive/73f628b.tar.gz"
  version "5.0.0"
  revision 1
  sha256 "f4b09b13746a2ba2a51be1fbeed78a19ab16f96defd0036cc8950fcb0279321d"
  license "AGPL-3.0-or-later"

  depends_on "python@3.13"
  depends_on "uv"

  def install
    libexec.install Dir["*"]

    (bin/"zotero-pdf2zh-next").write <<~SH
      #!/usr/bin/env bash
      set -euo pipefail

      ROOT="#{opt_libexec}/server"
      DATA="#{var}/zotero-pdf2zh-next"
      CACHE="#{var}/cache/zotero-pdf2zh-next/uv"
      PYTHON="#{Formula["python@3.13"].opt_bin}/python3.13"

      mkdir -p "$DATA" "$CACHE"

      export UV_CACHE_DIR="$CACHE"
      export UV_PROJECT_ENVIRONMENT="$DATA/.venv"

      exec "#{Formula["uv"].opt_bin}/uv" run --directory "$ROOT" --locked --python "$PYTHON" zotero-pdf2zh-next "$@"
    SH
    chmod 0755, bin/"zotero-pdf2zh-next"
  end

  service do
    run [opt_bin/"zotero-pdf2zh-next", "--host", "127.0.0.1", "--port", "8890", "--log-level", "INFO"]
    keep_alive true
    log_path var/"log/zotero-pdf2zh-next.log"
    error_log_path var/"log/zotero-pdf2zh-next.log"
  end

  test do
    output = shell_output("#{bin}/zotero-pdf2zh-next --help")
    assert_match "Run the zotero-pdf2zh-next server", output
  end
end
