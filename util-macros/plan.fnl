;; util-macros, ported from its plan.sh.
{:name :util-macros
 :origin :karate
 :version :1.19.1
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:MIT]
 :description "X.Org X11 Autotools macros"
 :upstream_url "https://www.x.org/"
 :source {:url "https://www.x.org/releases/individual/util/util-macros-1.19.1.tar.bz2"
          :sha256 :18d459400558f4ea99527bc9786c033965a3db45bf4c6a32eefdc07aa9e306a6}
 :build_deps [:karate/make]
 :pconfig_dirs [:share/pkgconfig]
 :check (fn [b]
          (b:run [:make :check]))}
