class Apel < Formula
  desc "Emacs Lisp library to help write portable Emacs programs"
  homepage "http://git.chise.org/elisp/apel/"
  url "http://git.chise.org/elisp/dist/apel/apel-10.8.tar.gz"
  sha256 "a511cc36bb51dc32b4915c9e03c67a994060b3156ceeab6fafa0be7874b9ccfe"

  bottle do
    cellar :any_skip_relocation
    sha256 "f47d90fd2aea06a0e52a75b84af03c7a97f479f00f621168eb5afb6f911e999f" => :el_capitan
    sha256 "90038f974eb80c5d670990f349a13d629e2139098720ca13b5a26c7c9a8c9360" => :yosemite
    sha256 "00acef6949043235fc8a613c1d5dc9f58d8e365bde486d42461fc89449ff834b" => :mavericks
    sha256 "64848e503581ebb1242cfe0924ebffa2c805b5213ae11541571f11bcb30c7dc9" => :x86_64_linux
  end

  def install
    system "make", "install", "PREFIX=#{prefix}",
           "LISPDIR=#{elisp}", "VERSION_SPECIFIC_LISPDIR=#{elisp}"
  end

  test do
    program = testpath/"test-apel.el"
    program.write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}/emu")
      (require 'poe)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{program}").strip
  end
end
