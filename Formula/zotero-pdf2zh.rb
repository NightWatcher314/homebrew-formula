class ZoteroPdf2zh < Formula

  desc "Zotero PDF → ZH local server"
  homepage "https://github.com/guaguastandup/zotero-pdf2zh"
  url "https://github.com/guaguastandup/zotero-pdf2zh/releases/download/v3.0.37/server.zip"
  sha256 "e41b6b9d951034b74bc7407ba7faf5afe4a383accfa571c2fc9896cb189fb4c3"

  depends_on "uv"

  def install
    # Unzip the downloaded file and install the contents into libexec
    libexec.install Dir["*"]

    # Create virtual environments and install dependencies
    cd libexec do
      # Create zotero-pdf2zh-venv environment
      ohai "Creating zotero-pdf2zh-venv environment..."
      system Formula["uv"].opt_bin/"uv", "venv", "zotero-pdf2zh-venv", "--python=3.12"
      
      # Install dependencies for zotero-pdf2zh-venv
      ohai "Installing dependencies for zotero-pdf2zh-venv..."
      system "bash", "-c", <<~BASH
        source zotero-pdf2zh-venv/bin/activate
        #{Formula["uv"].opt_bin}/uv pip install pdf2zh==1.9.11 pypdf PyMuPDF flask numpy==2.2.0 toml pdfminer.six==20250416 packaging
        deactivate
      BASH

      # Create zotero-pdf2zh-next-venv environment
      ohai "Creating zotero-pdf2zh-next-venv environment..."
      system Formula["uv"].opt_bin/"uv", "venv", "zotero-pdf2zh-next-venv", "--python=3.12"
      
      # Install dependencies for zotero-pdf2zh-next-venv
      ohai "Installing dependencies for zotero-pdf2zh-next-venv..."
      system "bash", "-c", <<~BASH
        source zotero-pdf2zh-next-venv/bin/activate
        #{Formula["uv"].opt_bin}/uv pip install pdf2zh_next pypdf PyMuPDF flask toml babeldoc packaging
        deactivate
      BASH

      # Run babeldoc --warmup for zotero-pdf2zh-next-venv
      ohai "Running babeldoc --warmup..."
      system "zotero-pdf2zh-next-venv/bin/babeldoc", "--warmup"
    end

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
      # Run the server with uv and dependencies (pass through any extra args)
      exec "#{Formula["uv"].opt_bin}/uv" "run" --python 3.12 --with flask --with toml --with pypdf --with argparse --with PyMuPDF --with packaging server.py --check_update false "$@"
        SH
    chmod 0755, bin/"zotero-pdf2zh"
  end

  service do
    # Use the wrapper and default to the port used in run.sh
    run [bin/"zotero-pdf2zh", "--port", "47700", "--check_update", "false"]
    keep_alive true
    working_dir opt_libexec
    log_path var/"log/zotero-pdf2zh.log"
    error_log_path var/"log/zotero-pdf2zh.log"
  end

  test do
    # Ensure the wrapper is callable and prints help without starting the server
    system bin/"zotero-pdf2zh", "--help"
  end
end
