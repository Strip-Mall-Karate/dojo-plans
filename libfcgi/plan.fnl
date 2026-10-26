;; libfcgi, ported from its plan.sh.
{:name "libfcgi"
 :origin "karate"
 :version "2.4.0"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["custom"]
 :description "FastCGI is a language independent, scalable, open extension to CGI that provides high performance without the limitations of server specific APIs."
 :upstream_url "https://directory.fsf.org/wiki/Libfcgi"
 :source {:url "http://ftp.debian.org/debian/pool/main/libf/libfcgi/libfcgi_2.4.0.orig.tar.gz" :sha256 "c21f553f41141a847b2f1a568ec99a3068262821e4e30bc9d4b5d9091aa0b5f7" :filename "libfcgi_2.4.0.orig.tar.gz" :dirname "libfcgi-2.4.0.orig"}
 :deps ["karate/glibc" "karate/gcc-libs"]
 :build_deps ["karate/make" "karate/gcc" "karate/patch"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :build (fn [b]
          (b:run ["patch" "-p0" "-i" (.. b.plan_dir "/stdio.patch")])
          (b.default.build b))
 :install (fn [b]
          (b.default.install b)
          (if (b:exists (.. b.prefix "/LICENSE"))
            (b:copy (b:join b.src "LICENSE.TERMS") (b:join (.. b.prefix "/LICENSE") (: (b:join b.src "LICENSE.TERMS") :match "[^/]+$")))
            (b:copy (b:join b.src "LICENSE.TERMS") (.. b.prefix "/LICENSE"))))}
