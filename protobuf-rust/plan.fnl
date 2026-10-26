;; protobuf-rust, ported from its plan.sh.
{:name "protobuf-rust"
 :origin "karate"
 :version "1.7.4"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["BSD"]
 :description "Rust implementation of Google protocol buffers"
 :upstream_url "https://github.com/stepancheg/rust-protobuf"
 :deps ["karate/glibc" "karate/gcc-libs"]
 :build_deps ["karate/rust"]
 :bin_dirs ["bin"]
 :download (fn [b]
          nil)
 :build (fn [b]
          (b:run ["cargo" "install" "protobuf" "--root" b.prefix "--vers" b.version (.. "-j" (tostring b.jobs)) "--verbose"]))
 :install (fn [b]
          nil)}
