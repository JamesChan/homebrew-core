class Fontconfig < Formula
  desc "XML-based font configuration API for X Windows"
  homepage "https://wiki.freedesktop.org/www/Software/fontconfig/"
  url "https://www.freedesktop.org/software/fontconfig/release/fontconfig-2.12.1.tar.bz2"
  sha256 "b449a3e10c47e1d1c7a6ec6e2016cca73d3bd68fbbd4f0ae5cc6b573f7d6c7f3"

  # The bottle tooling is too lenient and thinks fontconfig
  # is relocatable, but it has hardcoded paths in the executables.
  bottle do
    cellar :any
    sha256 "8e25522a54e6a127a090fc18c656e15d3380b1560300532d3471ae6a931452d3" => :el_capitan
    sha256 "cb47cfa3ba993e1a98216ece515868f97120169cc5ec3d136656348c2da7b581" => :yosemite
    sha256 "f24eb3f1a6a5d3d9c19ae54c6d8b818690d8d9353f53478c9baa5d2bde02c42b" => :mavericks
    sha256 "4782e225622a96410492b1c264327474a7dd0e895117304708caf7e1cfc7bc25" => :x86_64_linux
  end

  pour_bottle? do
    default_prefix = BottleSpecification::DEFAULT_PREFIX
    reason "The bottle needs to be installed into #{default_prefix}."
    # c.f. the identical hack in lua
    # https://github.com/Homebrew/homebrew/issues/47173
    satisfy { HOMEBREW_PREFIX.to_s == default_prefix }
  end

  keg_only :provided_pre_mountain_lion

  option :universal

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "bzip2" => :recommended unless OS.mac?
  depends_on "expat" unless OS.mac?

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--enable-static",
                          "--with-add-fonts=/System/Library/Fonts,/Library/Fonts,~/Library/Fonts",
                          "--prefix=#{prefix}",
                          "--localstatedir=#{var}",
                          "--sysconfdir=#{etc}"
    system "make", "install", "RUN_FC_CACHE_TEST=false"
  end

  def post_install
    ohai "Regenerating font cache, this may take a while"
    system "#{bin}/fc-cache", "-frv"
  end

  test do
    system "#{bin}/fc-list"
  end
end
