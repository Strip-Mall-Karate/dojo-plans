;; gamin, ported from its plan.sh.
{:name :gamin
 :origin :karate
 :version :0.1.10
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:LGPL-2.0]
 :description "File Alteration Monitor"
 :upstream_url "https://people.gnome.org/~veillard/gamin/"
 :source {:url "https://download.gnome.org/sources/gamin/0.1/gamin-0.1.10.tar.bz2"
          :sha256 :a59948b20ce2f14136c013f155abb8c8d51db2ea167c063ff33461e453fec10a}
 :deps [:karate/glib]
 :build_deps [:karate/diffutils
              :karate/gcc
              :karate/make
              :karate/patch
              :karate/pcre
              :karate/pkg-config
              :karate/python2]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :pconfig_dirs [:lib/pkgconfig]
 :prepare (fn [b]
            (b:run [:patch
                    :-p1
                    :-i
                    (.. b.plan_dir :/patches/fix-deprecated-const.patch)]))}
