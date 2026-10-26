;; wrk, ported from its plan.sh.
{:name "wrk"
 :origin "karate"
 :version "4.0.2"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["Apache-2.0"]
 :description "Modern HTTP benchmarking tool"
 :upstream_url "https://github.com/wg/wrk"
 :source {:url "https://github.com/wg/wrk/archive/4.0.2.tar.gz" :sha256 "a4a6ad6727733023771163e7250189a9a23e6253b5e5025191baa6092d5a26fb"}
 :deps ["karate/openssl" "karate/gcc" "karate/zlib"]
 :build_deps ["karate/make"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :build (fn [b]
          (b:run ["make" (.. "WITH_OPENSSL=" (b:path_for "karate/openssl"))]))
 :install (fn [b]
          (if (b:exists (.. b.prefix "/bin"))
            (b:copy (.. b.src "/" b.name) (b:join (.. b.prefix "/bin") (: (.. b.src "/" b.name) :match "[^/]+$")))
            (b:copy (.. b.src "/" b.name) (.. b.prefix "/bin"))))}
