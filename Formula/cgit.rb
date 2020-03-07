class Cgit < Formula
  desc "Hyperfast web frontend for Git repositories written in C"
  homepage "https://git.zx2c4.com/cgit/"
  url "https://git.zx2c4.com/cgit/snapshot/cgit-1.2.2.tar.xz"
  sha256 "3f97ce944d0f3fe0782bea3c46eafa5ff151212ea5bec31f99e5cb1775d4b236"

  bottle do
    rebuild 1
    sha256 "6ddf371689a429df59b81cc75ef3c491c58fa1536aeafb41eef0df89196405c6" => :catalina
    sha256 "0a8124c41a3e891d8ac8a9dc9391a1048deecb3b82a785d604bbf1d59125b010" => :mojave
    sha256 "b5dd8fcf3e81b7d320ea39d9de0b7a3b20b6522978e01f2527e14845d80454c4" => :high_sierra
    sha256 "7b21a1dd7536c3354280089b4521fa64e36c2d177303bf5f9ea7994b77a25f2d" => :sierra
  end

  depends_on "gettext"
  depends_on "openssl@1.1"

  # git version is mandated by cgit: see GIT_VER variable in Makefile
  # https://git.zx2c4.com/cgit/tree/Makefile?h=v1.2.2#n17
  resource "git" do
    url "https://www.kernel.org/pub/software/scm/git/git-2.25.0.tar.xz"
    sha256 "c060291a3ffb43d7c99f4aa5c4d37d3751cf6bca683e7344ea407ea504d9a8d0"
  end

  def install
    resource("git").stage(buildpath/"git")
    system "make", "prefix=#{prefix}",
                   "CGIT_SCRIPT_PATH=#{pkgshare}",
                   "CGIT_DATA_PATH=#{var}/www/htdocs/cgit",
                   "CGIT_CONFIG=#{etc}/cgitrc",
                   "CACHE_ROOT=#{var}/cache/cgit",
                   "install"
  end

  test do
    (testpath/"cgitrc").write <<~EOS
      repo.url=test
      repo.path=#{testpath}
      repo.desc=the master foo repository
      repo.owner=fooman@example.com
    EOS

    ENV["CGIT_CONFIG"] = testpath/"cgitrc"
    # no "Status" line means 200
    assert_no_match /Status: .+/, shell_output("#{pkgshare}/cgit.cgi")
  end
end
