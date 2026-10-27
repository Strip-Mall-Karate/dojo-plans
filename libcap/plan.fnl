;; libcap, ported from its plan.sh.
;; libcap 2.78, the latest release on 2026-10-26.
{:name :libcap
 :origin :karate
 :version :2.78
 :targets [:x86_64-linux :x86_64-linux-kernel2]
 :maintainer "Strip Mall Karate Company"
 :license [:gplv2]
 :description "POSIX 1003.1e capabilities."
 :upstream_url "http://sites.google.com/site/fullycapable/"
 :source {:url "https://www.kernel.org/pub/linux/libs/security/linux-privs/libcap2/libcap-2.78.tar.xz"
          :sha256 :0d621e562fd932ccf67b9660fb018e468a683d7b827541df27813228c996bb11}
 :deps [:karate/glibc :karate/attr]
 :build_deps [:karate/coreutils
              :karate/diffutils
              :karate/patch
              :karate/make
              :karate/gcc
              :karate/linux-headers
              :karate/perl]
 :bin_dirs [:bin]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :prepare (fn [b]
            (b.default.prepare b))
 :build (fn [b]
          (b:run [:make
                  :sbin=bin
                  :GOLANG=no
                  :PAM_CAP=no
                  :USE_GPERF=no
                  (.. :KERNEL_HEADERS= (b:path_for :linux-headers) :/include)
                  (.. :LDFLAGS= (or (b:getenv :LDFLAGS) ""))]))
 :install (fn [b]
            (b:run [:make
                    (.. :prefix= b.prefix)
                    :lib=lib
                    :sbin=bin
                    :GOLANG=no
                    :PAM_CAP=no
                    :USE_GPERF=no
                    :RAISE_SETFCAP=no
                    :install]))
 :on {:x86_64-linux-kernel2 {:version :2.78
                             :license [:gplv2]
                             :description "POSIX 1003.1e capabilities."
                             :upstream_url "http://sites.google.com/site/fullycapable/"
                             :source {:url "https://www.kernel.org/pub/linux/libs/security/linux-privs/libcap2/libcap-2.78.tar.xz"
                                      :sha256 :0d621e562fd932ccf67b9660fb018e468a683d7b827541df27813228c996bb11}
                             :deps [:karate/glibc :karate/attr]
                             :build_deps [:karate/coreutils
                                          :karate/diffutils
                                          :karate/patch
                                          :karate/make
                                          :karate/gcc
                                          :karate/linux-headers
                                          :karate/perl]
                             :bin_dirs [:bin]
                             :lib_dirs [:lib]
                             :include_dirs [:include]
                             :prepare (fn [b]
                                        (b.default.prepare b)
                                        (b:run [:patch
                                                :-p1
                                                :-i
                                                (.. (.. b.plan_dir
                                                        :/x86_64-linux-kernel2)
                                                    :/libcap-old-kernel-headers.patch)]))
                             :build (fn [b]
                                      (b:run [:make
                                              :sbin=bin
                                              :GOLANG=no
                                              :PAM_CAP=no
                                              :USE_GPERF=no
                                              (.. :KERNEL_HEADERS=
                                                  (b:path_for :linux-headers)
                                                  :/include)
                                              (.. :LDFLAGS=
                                                  (or (b:getenv :LDFLAGS) ""))]))
                             :install (fn [b]
                                        (b:run [:make
                                                (.. :prefix= b.prefix)
                                                :lib=lib
                                                :sbin=bin
                                                :GOLANG=no
                                                :PAM_CAP=no
                                                :USE_GPERF=no
                                                :RAISE_SETFCAP=no
                                                :install]))}}}
