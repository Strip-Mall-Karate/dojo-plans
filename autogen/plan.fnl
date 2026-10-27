;; autogen, ported from its plan.sh.
{:name :autogen
 :origin :karate
 :version :5.18.10
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:GPL-3.0]
 :description "A tool designed to simplify the creation and maintenance of programs that contain large amounts of repetitious text"
 :upstream_url "https://www.gnu.org/software/autogen/"
 :source {:url "http://ftp.gnu.org/gnu/autogen/rel5.18.10/autogen-5.18.10.tar.gz"
          :sha256 :0b8681d9724c481d3b726b5a9e81d3d09dc7f307d1a801c76d0a30d8f843d20a}
 :deps [:karate/glibc
        :karate/gcc-libs
        :karate/guile
        :karate/libxml2
        :karate/zlib]
 :build_deps [:karate/gcc
              :karate/make
              :karate/pkg-config
              :karate/diffutils
              :karate/which
              :karate/perl]
 :bin_dirs [:bin]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :check (fn [b]
          (b:run [:make :check]))}
