;; goaccess, ported from its plan.sh.
{:name "goaccess"
 :origin "karate"
 :version "1.3"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["MIT"]
 :description "GoAccess is a real-time web log analyzer and interactive viewer that runs in a terminal in *nix systems or through your browser."
 :upstream_url "https://goaccess.io/"
 :source {:url "https://github.com/allinurl/goaccess/archive/v1.3.tar.gz" :sha256 "b231f23b7ae106da9e8aea34755a72891649b221dfb94cfab525e527829d5af7"}
 :deps ["karate/glibc" "karate/libmaxminddb" "karate/ncurses"]
 :build_deps ["karate/autoconf" "karate/automake" "karate/gawk" "karate/gcc" "karate/gettext" "karate/make"]
 :bin_dirs ["bin"]
 :build (fn [b]
          (b:run ["autoreconf" "-fiv"])
          (b:run ["./configure" (.. "--prefix=" b.prefix) "--enable-utf8" "--enable-geoip=mmdb"])
          (b:run ["make"]))
 :install (fn [b]
          (b.default.install b)
          (b:copy (b:join b.src "COPYING") (b:join (.. b.prefix "/") (: (b:join b.src "COPYING") :match "[^/]+$"))))}
