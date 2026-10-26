;; libghthash, ported from its plan.sh.
{:name "libghthash"
 :origin "karate"
 :version "0.6.2"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["LGPL-2.0"]
 :description "Generic Hash Table which is meant to be easy to extend, portable, clear in its code and easy to use."
 :upstream_url "https://github.com/SimonKagstrom/libghthash"
 :source {:url "https://github.com/SimonKagstrom/libghthash/archive/v0.6.2.tar.gz" :sha256 "e7e5f77df3e2a9152e0805f279ac048af9e572b83e60d29257cc754f8f9c22d6"}
 :deps ["karate/glibc"]
 :build_deps ["karate/autoconf" "karate/automake" "karate/gcc" "karate/libtool" "karate/make"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :build (fn [b]
          (let [text (b:read (b:join b.src "configure.in"))] (b:write (b:join b.src "configure.in") (pick-values 1 (string.gsub text "[^\n]+" (fn [l] (var line l) (set line (pick-values 1 (string.gsub line "AM_PROG_LIBTOOL%(%)" "LT_INIT"))) line)))))
          (b:write (b:join b.src "configure.in") (.. (if (b:exists (b:join b.src "configure.in")) (b:read (b:join b.src "configure.in")) "") "AC_CONFIG_MACRO_DIRS([m4])\n"))
          (b:run ["libtoolize"])
          (b:run ["aclocal" "-I" "m4"])
          (b:run ["autoconf"])
          (b:run ["automake" "--add-missing"])
          (b.default.build b))}
