class ZoteroPdf2zhNext < Formula
  desc "Minimal Zotero pdf2zh_next local server"
  homepage "https://github.com/NightWatcher314/zotero-pdf2zh-next"
  url "https://github.com/NightWatcher314/zotero-pdf2zh-next/archive/adf48f8.tar.gz"
  version "5.2.6"
  sha256 "959683f87a034008c94f9170d03e9cf35adb114936ff4439a01208885e8452ec"
  license "AGPL-3.0-or-later"

  depends_on "uv" => :build
  depends_on "python@3.13"
  depends_on "spatialindex"

  def install
    libexec.install Dir["*"]

    ENV["UV_NO_CONFIG"] = "1"
    ENV["UV_PROJECT_ENVIRONMENT"] = libexec/"venv"

    system "uv", "sync",
           "--project", libexec/"server",
           "--locked",
           "--no-dev",
           "--no-editable",
           "--python", Formula["python@3.13"].opt_bin/"python3.13"

    (bin/"zotero-pdf2zh-next").write <<~SH
      #!/usr/bin/env bash
      set -euo pipefail

      export LD_LIBRARY_PATH="#{Formula["spatialindex"].opt_lib}:${LD_LIBRARY_PATH:-}"
      exec "#{opt_libexec}/venv/bin/zotero-pdf2zh-next" "$@"
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
