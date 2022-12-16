class Picolisp < Formula
  desc "PicoLisp is a programming language, a dialect of the language Lisp."
  homepage "https://picolisp.com/wiki/?home"
  url "https://software-lab.de/pil21.tgz"
  version "21"
  sha256 "01c9e74d1597208588426b8df2d54f8a1214e41877399fb7f6ae01181d35703d"
  license "MIT"

  depends_on "openssl@1.1"
  depends_on "libffi"
  depends_on "readline"
  depends_on "w3m"
  depends_on "llvm" => :build
  
  def install
    system "cd src; make SHARED='-dynamiclib -undefined dynamic_lookup' STRIP=':'"
    inreplace ["bin/pil", "lib/bash_completion", "man/man1/picolisp.1", "bin/vip"] do |s|
      s.gsub! "/usr", HOMEBREW_PREFIX
    end
    inreplace Dir["doc/*.html"] do |s|
      s.gsub! "/usr", HOMEBREW_PREFIX, false
    end
    bash_completion.install "lib/bash_completion" => "picolisp"
    man.install "man/man1"
    bin.install "bin/pil", "bin/picolisp"
    (lib/"picolisp").install "ext.l", "lib.l", "lib.css", "lib", "img", "loc", "doc", "misc", "test"
    (lib/"picolisp/src").install Dir["src/.h", "src/*.ll", "src/*.c", "src/*.l", "src/*.s"], "src/MakeFile", "src/lib"
    (lib/"picolisp/bin").install "bin/balance", "bin/httpGate", "bin/psh", "bin/ssl", "bin/vip", "bin/watchdog", "bin/pty"
    doc.install "README", "INSTALL", "COPYING"
  end

  test do
    system "#{bin}/pil -version -bye"
  end
end
