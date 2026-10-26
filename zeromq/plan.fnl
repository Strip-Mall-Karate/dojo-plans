;; zeromq, ported from its plan.sh.
{:name "zeromq"
 :origin "karate"
 :version "4.2.5"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["LGPL"]
 :description "ZeroMQ core engine in C++, implements ZMTP/3.1"
 :upstream_url "http://zeromq.org"
 :source {:url "https://github.com/zeromq/libzmq/releases/download/v4.2.5/zeromq-4.2.5.tar.gz" :sha256 "cc9090ba35713d59bb2f7d7965f877036c49c5558ea0c290b0dcc6f2a17e489f"}
 :deps ["karate/glibc" "karate/gcc-libs" "karate/libsodium"]
 :build_deps ["karate/gcc" "karate/diffutils" "karate/coreutils" "karate/make" "karate/pkg-config" "karate/patchelf" "karate/busybox-static" "karate/shadow"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :check (fn [b]
          (b:run ["gpasswd" "-a" "root" "dialout"])
          (b:run ["make" "check"])
          (b:run ["gpasswd" "-d" "root" "dialout"]))
 :install (fn [b]
          (b.default.install b)
          (each [_ f (ipairs (b:find (b:join b.prefix "lib") "*.so"))]
            (b:run ["patchelf" "--set-rpath" (or (b:getenv "LD_RUN_PATH") "") f])))}
