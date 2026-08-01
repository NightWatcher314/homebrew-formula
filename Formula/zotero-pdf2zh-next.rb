class ZoteroPdf2zhNext < Formula
  desc "Minimal Zotero pdf2zh_next local server"
  homepage "https://github.com/NightWatcher314/zotero-pdf2zh-next"
  url "https://github.com/NightWatcher314/zotero-pdf2zh-next/archive/323d3fd6acbc7e23e7539a610133be81a9eeb7eb.tar.gz"
  version "5.2.9"
  sha256 "3ff39d83fca2183f7bc03a158e98a16b0b207bfd75d35b46704b35c027e4e30e"
  license "AGPL-3.0-or-later"
  revision 1

  bottle do
    root_url "https://github.com/NightWatcher314/homebrew-formula/releases/download/zotero-pdf2zh-next-5.2.9"
    sha256 arm64_tahoe: "a93371449cd0267ceace128a3284becddaefa3a5e9895c529a4f4cb9fb704828"
  end

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
    libexec.install "server/README.md", "server/pyproject.toml", "server/uv.lock"

    ENV["UV_NO_CONFIG"] = "1"
    ENV["UV_PROJECT_ENVIRONMENT"] = libexec/"venv"

    system "uv", "sync",
           "--project", libexec,
           "--locked",
           "--no-dev",
           "--no-editable",
           "--python", formula_opt_bin("python@3.13")/"python3.13"

    if OS.linux?
      site_packages = Pathname(Dir[(libexec/"venv/lib/python*/site-packages").to_s].fetch(0))
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
  end
end
