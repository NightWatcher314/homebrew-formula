class ZoteroPdf2zhNext < Formula
  desc "Minimal Zotero pdf2zh_next local server"
  homepage "https://github.com/NightWatcher314/zotero-pdf2zh-next"
  url "https://github.com/NightWatcher314/zotero-pdf2zh-next/archive/c25c40a91ebbfe5642c58522b2955706ab097332.tar.gz"
  version "5.2.8"
  sha256 "d7ea2a635f13d1b68d86fd7672af7362c25ec70e9bd86db3fdd043c9d73cd7c7"
  license "AGPL-3.0-or-later"

  depends_on "uv" => :build
  depends_on "python@3.13"
  depends_on "spatialindex"
  preserve_rpath

  def install
    libexec.install Dir["server/*.py"]
    libexec.install "server/README.md", "server/pyproject.toml", "server/uv.lock"

    ENV["UV_NO_CONFIG"] = "1"
    ENV["UV_PROJECT_ENVIRONMENT"] = libexec/"venv"

    system "uv", "sync",
           "--project", libexec,
           "--locked",
           "--no-dev",
           "--no-editable",
           "--python", formula_opt_bin("python@3.13")/"python3.13"

    (bin/"zotero-pdf2zh-next").write <<~SH
      #!/usr/bin/env bash
      set -euo pipefail

      export LD_LIBRARY_PATH="#{formula_opt_lib("spatialindex")}:${LD_LIBRARY_PATH:-}"
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
