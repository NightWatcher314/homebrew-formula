class ZoteroPdf2zhNext < Formula
  desc "Minimal Zotero pdf2zh_next local server"
  homepage "https://github.com/NightWatcher314/zotero-pdf2zh-next"
  url "https://github.com/NightWatcher314/zotero-pdf2zh-next/archive/c518aa1010075202394abd325e7862e4999c9f5e.tar.gz"
  version "5.3.0"
  sha256 "10c89f1d1f5b60d67a92dc84ab7ff39e55d7911921591a9ffb832c787ea5be11"
  license "AGPL-3.0-or-later"

  depends_on "uv" => :build
  depends_on "python@3.13"
  depends_on "spatialindex"

  on_linux do
    depends_on "patchelf" => :build
    depends_on "zlib-ng-compat"
  end

  preserve_rpath

  def install
    libexec.install Dir["server/*.py"]
    libexec.install "server/LICENSES", "server/babeldoc", "server/pdf2zh_next",
                    "server/rapidocr_onnxruntime"
    libexec.install "server/README.md", "server/THIRD_PARTY_NOTICES.md",
                    "server/pyproject.toml", "server/uv.lock"

    ENV.delete "UV_INDEX_URL"
    ENV.delete "PIP_INDEX_URL"
    ENV["UV_NO_CONFIG"] = "1"
    ENV["UV_DEFAULT_INDEX"] = "https://pypi.org/simple"
    ENV["UV_PROJECT_ENVIRONMENT"] = libexec/"venv"

    system "uv", "sync",
           "--project", libexec,
           "--locked",
           "--no-dev",
           "--no-editable",
           "--python", formula_opt_bin("python@3.13")/"python3.13"

    site_packages = Pathname(Dir[(libexec/"venv/lib/python*/site-packages").to_s].fetch(0))
    Dir[(site_packages/"**/{test,tests}").to_s].reverse_each do |test_path|
      path = Pathname(test_path)
      next if path.symlink? || !path.directory?

      rm_r path
    end
    rm libexec/"venv/bin/ruff" if (libexec/"venv/bin/ruff").exist?
    rm_r site_packages/"cv2/data" if (site_packages/"cv2/data").exist?
    rm_r site_packages/"skimage/data" if (site_packages/"skimage/data").exist?

    if OS.linux?
      zlib_lib = formula_opt_lib("zlib-ng-compat").to_s

      Dir[(site_packages/"**/*").to_s].each do |entry|
        file = Pathname(entry)
        next if file.symlink? || !file.file? || !file.elf?

        needed = Utils.safe_popen_read("patchelf", "--print-needed", file).lines(chomp: true)
        additions = []
        additions << "$ORIGIN" if needed.any? { |soname| (file.dirname/soname).exist? }
        additions << zlib_lib if needed.include?("libz.so.1")
        next if additions.empty?

        current = Utils.safe_popen_read("patchelf", "--print-rpath", file).strip.split(":").reject(&:empty?)
        patched = Pathname("#{file}.homebrew-rpath")
        cp file, patched, preserve: true
        system "patchelf", "--force-rpath", "--set-rpath", (current + additions).uniq.join(":"), patched
        mv patched, file
      end
    end

    library_paths = [formula_opt_lib("spatialindex")]
    library_paths << formula_opt_lib("zlib-ng-compat") if OS.linux?

    (bin/"zotero-pdf2zh-next").write <<~SH
      #!/usr/bin/env bash
      set -euo pipefail

      export LD_LIBRARY_PATH="#{library_paths.join(":")}:${LD_LIBRARY_PATH:-}"
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

    system libexec/"venv/bin/python", "-c", <<~PYTHON
      from pathlib import Path

      import babeldoc
      import cv2
      import pdf2zh_next
      import rapidocr_onnxruntime
      import skimage

      site_packages = Path(pdf2zh_next.__file__).resolve().parent.parent
      unwanted_tests = [
          path for path in site_packages.rglob("*")
          if path.is_dir() and path.name in {"test", "tests"}
      ]
      assert not unwanted_tests, unwanted_tests[:10]
      assert not (Path("#{libexec}/venv/bin/ruff")).exists()
      assert not (site_packages / "cv2/data").exists()
      assert not (site_packages / "skimage/data").exists()
      assert pdf2zh_next.__version__ == "2.8.2"
      assert babeldoc.__version__ == "0.5.24"
      assert rapidocr_onnxruntime.__file__
      assert cv2.__version__
      assert skimage.__version__
    PYTHON
  end
end
