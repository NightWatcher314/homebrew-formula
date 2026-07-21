class Sbarlua < Formula
  desc "Lua C module for SketchyBar"
  homepage "https://github.com/FelixKratz/SbarLua"
  url "https://github.com/FelixKratz/SbarLua/archive/dba9cc421b868c918d5c23c408544a28aadf2f2f.tar.gz"
  version "2026.03.06"
  sha256 "0805f298b4f99532fc576589566762cde9d596044977bbab1771e0c849d50721"
  license "GPL-3.0-only"

  depends_on "lua"
  depends_on :macos

  def install
    inreplace "Makefile" do |s|
      s.gsub! "src/*.c bin/liblua.a", "src/*.c | bin"
      s.gsub! "-I$(LUA_DIR)/src -Lbin -llua",
              "-I#{formula_opt_include("lua")}/lua -Wl,-undefined,dynamic_lookup"
    end

    system "make", "install", "INSTALL_DIR=#{lib}/lua/5.5"
  end

  test do
    assert_path_exists lib/"lua/5.5/sketchybar.so"
    system formula_opt_bin("lua")/"lua", "-e", 'local s = require("sketchybar"); assert(s)'
  end
end
