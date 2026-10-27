;; sccache, ported from its plan.sh.
{:name :sccache
 :origin :karate
 :version :0.2.4
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:Apache-2.0]
 :description "sccache is ccache with cloud storage"
 :upstream_url "https://github.com/mozilla/sccache"
 :source {:url "https://github.com/mozilla/sccache/archive/0.2.4.tar.gz"
          :sha256 :82d8d553a0cf2752e71266523f9aac30c1b5a12fa6b1faea8c7c6e1ec9827371}
 :deps [:karate/glibc :karate/gcc-libs :karate/openssl]
 :build_deps [:karate/rust
              :karate/gcc
              :karate/pkg-config
              :karate/openssl
              :karate/make]
 :bin_dirs [:bin]
 :svc {:user :root :group :root}
 :build (fn [b]
          (b:run [:cargo :build :--release]))
 :install (fn [b]
            (b:run [:cargo :install :--root b.prefix]))}
