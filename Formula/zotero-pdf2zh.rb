class ZoteroPdf2zh < Formula
  desc "Zotero PDF → ZH local server"
  homepage "https://github.com/guaguastandup/zotero-pdf2zh"
  url "https://github.com/guaguastandup/zotero-pdf2zh/releases/download/v4.0.3/server.zip"
  sha256 "9a125fb1a4d16029d297bc3691b02282670c60cd91db098e45e029691e407b69"
  license "AGPL-3.0-or-later"

  depends_on "uv" => :build
  depends_on "python@3.12"
  depends_on "spatialindex"

  def install
    libexec.install Dir["*"]

    ENV["UV_NO_CONFIG"] = "1"
    system "uv", "venv", libexec/"venv", "--python", Formula["python@3.12"].opt_bin/"python3.12"
    system "uv", "pip", "install",
           "--python", libexec/"venv/bin/python",
           "flask",
           "toml",
           "pypdf",
           "argparse",
           "PyMuPDF",
           "packaging",
           "pdf2zh_next"

    (bin/"zotero-pdf2zh").write <<~SH
      #!/usr/bin/env bash
      set -euo pipefail

      ROOT="#{opt_libexec}"
      DATA="${ZOTERO_PDF2ZH_DATA:-#{var}/zotero-pdf2zh}"
      APP="$DATA/app"
      SRC_CFG="$ROOT/config"
      DST_CFG="$DATA/config"
      PYTHON="#{opt_libexec}/venv/bin/python"

      export LD_LIBRARY_PATH="#{Formula["spatialindex"].opt_lib}:${LD_LIBRARY_PATH:-}"

      mkdir -p "$APP" "$DST_CFG" "$DATA/translated"

      for item in bo.mp3 favicon.svg index.html server.py requirements.txt README-v4.0.1.pdf utils warmup doc; do
        if [ -e "$ROOT/$item" ]; then
          rm -rf "$APP/$item"
          cp -R "$ROOT/$item" "$APP/$item"
        fi
      done

      if [ -d "$SRC_CFG" ]; then
        for f in "$SRC_CFG"/*.example; do
          [ -f "$f" ] || continue
          base="$(basename "$f")"
          if [ ! -f "$DST_CFG/$base" ]; then
            cp "$f" "$DST_CFG/$base"
          fi
        done
      fi

      rm -rf "$APP/config" "$APP/translated"
      ln -snf "$DST_CFG" "$APP/config"
      ln -snf "$DATA/translated" "$APP/translated"

      cd "$APP"
      exec "$PYTHON" server.py --check_update false "$@"
    SH
    chmod 0755, bin/"zotero-pdf2zh"
  end

  service do
    run [opt_bin/"zotero-pdf2zh", "--port", "47700", "--check_update", "false"]
    keep_alive true
    working_dir opt_libexec
    log_path var/"log/zotero-pdf2zh.log"
    error_log_path var/"log/zotero-pdf2zh.log"
  end

  test do
    ENV["ZOTERO_PDF2ZH_DATA"] = testpath/"data"

    system bin/"zotero-pdf2zh", "--help"
  end
end
