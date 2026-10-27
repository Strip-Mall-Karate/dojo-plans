;; rq, ported from its plan.sh.
;; rq 1.0.2, the latest release on 2026-10-26.
{:name :rq
 :origin :karate
 :version :1.0.2
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:Apache-2.0]
 :description "Record Query is a tool for doing record analysis and transformation. It's used for performing queries on streams of records in various formats."
 :upstream_url "https://github.com/dflemstr/rq"
 :source {:url "https://github.com/dflemstr/rq/releases/download/v1.0.2/rq-v1.0.2-x86_64-unknown-linux-gnu.tar.gz"
          :sha256 :b870456796c27f358090a5e68944d912beb4280bc7010912cb3d6753f2da936c
          :filename :rq-v1.0.2-x86_64-unknown-linux-gnu.tar.gz}
 :deps [:karate/glibc :karate/gcc-libs]
 :build_deps [:karate/patchelf]
 :bin_dirs [:bin]
 :unpack (fn [b]
           ;; The release tarball holds the bare rq binary, no directory.
           (b.default.unpack b)
           (b:mkdir (.. b.cache "/" (.. b.name "-" b.version)))
           (b:move (.. b.cache :/rq)
                   (.. b.cache "/" (.. b.name "-" b.version) :/rq)))
 :build (fn [b]
          nil)
 :install (fn [b]
            (b:copy (b:join b.src :rq) (.. b.prefix :/bin/ b.name))
            (b:chmod (.. b.prefix :/bin/ b.name) :755))
 :strip (fn [b]
          (b.default.strip b)
          (b:run [:patchelf
                  :--interpreter
                  (.. (b:path_for :karate/glibc) :/lib/ld-linux-x86-64.so.2)
                  :--set-rpath
                  (or (b:getenv :LD_RUN_PATH) "")
                  (.. b.prefix :/bin/rq)]))}
