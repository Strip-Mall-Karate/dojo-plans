;; varnish, ported from its plan.sh.
{:name "varnish"
 :origin "karate"
 :version "5.1.2"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["bsd"]
 :description "Varnish Cache"
 :upstream_url "http://varnish-cache.org/"
 :source {:url "https://varnish-cache.org/_downloads/varnish-5.1.2.tgz" :sha256 "39d858137e26948a7c85f07363f13f0778da61d234126e03a160a0cb9ba4fce3"}
 :deps ["karate/bash" "karate/gcc" "karate/glibc" "karate/ncurses" "karate/pcre"]
 :build_deps ["karate/autoconf" "karate/automake" "karate/docutils" "karate/graphviz" "karate/libedit" "karate/libtool" "karate/make" "karate/pkg-config" "karate/python2" "karate/readline" "karate/m4"]
 :bin_dirs ["bin" "sbin"]
 :exports {"port" "frontend.port"}
 :download (fn [b]
          ;; From do_begin.
          (b.default.download b))
 :prepare (fn [b]
          nil)
 :build (fn [b]
          (b:copy (.. (b:path_for "karate/pkg-config") "/share/aclocal/pkg.m4") (b:join (.. (b:path_for "karate/automake") "/share/aclocal/") (: (.. (b:path_for "karate/pkg-config") "/share/aclocal/pkg.m4") :match "[^/]+$")))
          (b:run ["sh" "autogen.sh"])
          (b:run ["sh" "configure" (.. "--prefix=" b.prefix)])
          (b:run ["make"]))
 :check (fn [b]
          nil)}
