class Picolisp < Formula
  desc "PicoLisp is a programming language, a dialect of the language Lisp."
  homepage "https://picolisp.com/wiki/?home"
  url "https://software-lab.de/pil21.tgz"
  version "21"
  sha256 "c940c59d8651e4b5da0ed881a810fc9225280e1fa53d83879f99bc15b4f4ea7e"
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
    system "#{bin}/pil <<EOF
(load \"@lib/clang.l\")

(clang \"ltest\" NIL
   (cbTest (Fun) cbTest 'N Fun) )

long cbTest(int(*fun)(int,int,int,int,int)) {
   return fun(1,2,3,4,5);
}
/**/

(cbTest
   (lisp 'cbTest
      '((A B C D E)
         (msg (list A B C D E))
         (* A B C D E) ) ) )
EOF"
  end
end
