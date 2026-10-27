;; compositeproto, ported from its plan.sh.
{:name :compositeproto
 :origin :karate
 :version :0.4
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:MIT]
 :description "X11 Composite extension header files"
 :upstream_url "https://www.x.org/"
 :source {:url "https://www.x.org/releases/individual/proto/compositeproto-0.4.tar.bz2"
          :sha256 :6013d1ca63b2b7540f6f99977090812b899852acfbd9df123b5ebaa911e30003}
 :build_deps [:karate/gcc :karate/make]
 :include_dirs [:include]
 :pconfig_dirs [:lib/pkgconfig]}
