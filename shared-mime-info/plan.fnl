;; shared-mime-info, ported from its plan.sh.
{:name :shared-mime-info
 :origin :karate
 :version :1.9
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:GPL-2.0]
 :description "The shared-mime-info package contains the core database of common types and the update-mime-database command used to extend it"
 :upstream_url "https://www.freedesktop.org/wiki/Software/shared-mime-info/"
 :source {:url "http://freedesktop.org/~hadess/shared-mime-info-1.9.tar.xz"
          :sha256 :5c0133ec4e228e41bdf52f726d271a2d821499c2ab97afd3aa3d6cf43efcdc83}
 :deps [:karate/glib :karate/glibc :karate/libxml2 :karate/pcre :karate/zlib]
 :build_deps [:karate/cpanminus
              :karate/expat
              :karate/gcc
              :karate/gettext
              :karate/intltool
              :karate/make
              :karate/perl
              :karate/pkg-config]
 :bin_dirs [:bin]
 :prepare (fn [b]
            (b.default.prepare b)
            (b:run [:cpanm
                    "XML::Parser"
                    (.. :--configure-args=EXPATLIBPATH=
                        (b:path_for :karate/expat) "/lib export EXPATINCPATH="
                        (b:path_for :karate/expat) :/include)]))}
