;; libfcgi, ported from its plan.sh.
;; libfcgi 2.4.7, the latest release on 2026-10-27: 2.4.0's source no longer downloads.
{:name :libfcgi
 :origin :karate
 :version :2.4.7
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:custom]
 :description "FastCGI is a language independent, scalable, open extension to CGI that provides high performance without the limitations of server specific APIs."
 :upstream_url "https://github.com/FastCGI-Archives/fcgi2"
 :source {:url "https://github.com/FastCGI-Archives/fcgi2/archive/refs/tags/2.4.7.tar.gz"
          :sha256 :e41ddc3a473b555bdc0cbd80703dcb1f4610c1a7700d3b9d3d0c14a416e1074b
          :filename :fcgi2-2.4.7.tar.gz
          :dirname :fcgi2-2.4.7}
 :deps [:karate/glibc :karate/gcc-libs]
 :build_deps [:karate/autoconf
              :karate/automake
              :karate/libtool
              :karate/make
              :karate/gcc
              :karate/patch]
 :bin_dirs [:bin]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :build (fn [b]
          (b:run [:patch :-p0 :-i (.. b.plan_dir :/stdio.patch)])
          (b:run [:autoreconf :--force :--install])
          (b.default.build b))
 :install (fn [b]
            (b.default.install b)
            (if (b:exists (.. b.prefix :/LICENSE))
                (b:copy (b:join b.src :LICENSE)
                        (b:join (.. b.prefix :/LICENSE)
                                (: (b:join b.src :LICENSE) :match "[^/]+$")))
                (b:copy (b:join b.src :LICENSE) (.. b.prefix :/LICENSE))))}
