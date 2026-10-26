;; rq, ported from its plan.sh.
{:name "rq"
 :origin "karate"
 :version "0.10.4"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["Apache-2.0"]
 :description "Record Query is a tool for doing record analysis and transformation. It's used for performing queries on streams of records in various formats."
 :upstream_url "https://github.com/dflemstr/rq"
 :source {:url "https://github.com/dflemstr/rq/releases/download/v0.10.4/record-query-v0.10.4-x86_64-unknown-linux-gnu.tar.gz" :sha256 "1b9abedd7acca1269ac1c4765d93bab73777feca9a04358ea4f9c9659bf51e62"}
 :deps ["karate/glibc" "karate/gcc-libs"]
 :build_deps ["karate/patchelf"]
 :bin_dirs ["bin"]
 :unpack (fn [b]
          (b.default.unpack b)
          (if (b:exists (.. b.cache "/" (.. b.name "-" b.version)))
            (b:move (.. b.cache "/x86_64-unknown-linux-gnu") (b:join (.. b.cache "/" (.. b.name "-" b.version)) (: (.. b.cache "/x86_64-unknown-linux-gnu") :match "[^/]+$")))
            (b:move (.. b.cache "/x86_64-unknown-linux-gnu") (.. b.cache "/" (.. b.name "-" b.version)))))
 :build (fn [b]
          nil)
 :install (fn [b]
          (b:copy (b:join b.src "rq") (.. b.prefix "/bin/" b.name))
          (b:chmod (.. b.prefix "/bin/" b.name) "755"))
 :strip (fn [b]
          (b.default.strip b)
          (b:run ["patchelf" "--interpreter" (.. (b:path_for "karate/glibc") "/lib/ld-linux-x86-64.so.2") "--set-rpath" (or (b:getenv "LD_RUN_PATH") "") (.. b.prefix "/bin/rq")]))}
