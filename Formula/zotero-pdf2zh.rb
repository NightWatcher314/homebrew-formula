class ZoteroPdf2zh < Formula

  desc "Zotero PDF → ZH local server"
  homepage "https://github.com/guaguastandup/zotero-pdf2zh"
  url "https://github.com/guaguastandup/zotero-pdf2zh/releases/download/v3.0.34/server.zip"
  sha256 "45fd7e8580ef3dc6850e7b65ff98591c1ba75b0c88eb638f883eafc603cc19d"

  depends_on "uv"

  def install
    # Unzip the downloaded file and install the contents into libexec
    libexec.install Dir["*"]

    # Wrapper: ensures writable config/data live under Homebrew var, then runs via venv.
    (bin/"zotero-pdf2zh").write <<~SH
      #!/usr/bin/env bash
      set -euo pipefail
      ROOT="#{opt_libexec}"
      DATA="#{var}/zotero-pdf2zh"
      SRC_CFG="$ROOT/config"
      DST_CFG="$DATA/config"

      mkdir -p "$DST_CFG" "$DATA/translated"
      # Seed example config files into writable config dir (if missing)
      if [ -d "$SRC_CFG" ]; then
        for f in "$SRC_CFG"/*.example; do
          [ -f "$f" ] || continue
          base="$(basename "$f")"
          if [ ! -f "$DST_CFG/$base" ]; then
        cp "$f" "$DST_CFG/$base"
          fi
        done
      fi
      # Link writable data into install tree and run
      cd "$ROOT"
      ln -snf "$DST_CFG" config
      ln -snf "$DATA/translated" translated
      # Run the server with Python 3.12 and dependencies (pass through any extra args)
      exec "uv" "run" --python 3.12 --with flask --with toml --with pypdf --with argparse --with PyMuPDF --with packaging server.py --check_update false "$@"
        SH
    chmod 0755, bin/"zotero-pdf2zh"
  end

  service do
    # Use the wrapper and default to the port used in run.sh
    run [opt_bin/"zotero-pdf2zh", "--port", "47700", "--check_update", "false"]
    keep_alive true
    # Run from libexec so relative paths resolve consistently
    working_dir opt_libexec
    log_path var/"log/zotero-pdf2zh.log"
    error_log_path var/"log/zotero-pdf2zh.log"
  end

  test do
    # Ensure the wrapper is callable and prints help without starting the server
    system bin/"zotero-pdf2zh", "--help"
  end
end
