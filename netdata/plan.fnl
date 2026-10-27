;; netdata, ported from its plan.sh.
{:name :netdata
 :origin :karate
 :version :1.10.0
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:GPL-3.0-or-later]
 :description "netdata is a system for distributed real-time performance and health monitoring."
 :upstream_url "https://github.com/firehol/netdata"
 :source {:url "https://github.com/firehol/netdata/archive/v1.10.0.tar.gz"
          :sha256 :645b1cb60a779132c816d1bad377574884992c214bbb0f7a483649878884dbab}
 :deps [:karate/bash
        :karate/curl
        :karate/gawk
        :karate/glibc
        :karate/python
        :karate/util-linux
        :karate/zlib
        :karate/coreutils]
 :build_deps [:karate/autoconf
              :karate/autogen
              :karate/automake
              :karate/pkg-config
              :karate/gcc
              :karate/make]
 :bin_dirs [:sbin]
 :svc {:run "netdata -D -c /doj/svc/netdata/config/netdata.conf"}
 :exports {:host :server.address :port :server.port}
 :exposes [:port]
 :build (fn [b]
          (b:fix_interpreter (b:glob b.src :*.sh) :karate/coreutils :bin/env)
          (b:run [:./autogen.sh]
                 {:env {:ACLOCAL_PATH (.. (b:path_for :karate/pkg-config)
                                          :/share/aclocal)}})
          (b:run [:./configure
                  (.. :--prefix= b.prefix)
                  :--with-zlib
                  :--with-math
                  :--with-user=doj])
          (b:run [:make]))
 :install (fn [b]
            (b.default.install b)
            (b:remove (b:join b.prefix :var))
            (b:log "Fixing libexec interpreters")
            (b:run [:find
                    :./libexec/netdata
                    :-type
                    :f
                    :-executable
                    :-print
                    :-exec
                    :bash
                    :-c
                    "sed -e \"s#\\#\\!/usr/bin/env bash#\\#\\!$1/bin/bash#\" --in-place \"$2\""
                    "_"
                    (b:path_for :bash)
                    "{}"
                    ";"] {:cwd b.prefix}))}
