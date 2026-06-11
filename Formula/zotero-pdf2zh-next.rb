class ZoteroPdf2zhNext < Formula
  desc "Minimal Zotero pdf2zh_next local server"
  homepage "https://github.com/NightWatcher314/zotero-pdf2zh-next"
  url "https://github.com/NightWatcher314/zotero-pdf2zh-next/archive/116eeda8b8709464cac74797cc01d383a0a8e3a7.tar.gz"
  version "5.2.3"
  sha256 "59db511814ad23eea98c079c05cb82d352b0ae4c38a9d9993e11f3559de3d105"
  license "AGPL-3.0-or-later"

  depends_on "uv" => :build
  depends_on "python@3.13"

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

    bin.install_symlink libexec/"venv/bin/zotero-pdf2zh-next"
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
