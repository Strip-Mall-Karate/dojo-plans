;; inotify-tools, ported from its plan.sh.
;; inotify-tools 4.25.9.0, the last C release on 2026-10-27 (4.26 is a Rust rewrite): 3.14's source no longer downloads.
{:name "inotify-tools"
 :origin "karate"
 :version "4.25.9.0"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["GPL-2.0"]
 :description "inotify-tools is a C library and a set of command-line programs for Linux providing a simple interface to inotify. These programs can be used to monitor and act upon filesystem events."
 :upstream_url "https://github.com/inotify-tools/inotify-tools"
 :source {:url "https://github.com/inotify-tools/inotify-tools/archive/refs/tags/4.25.9.0.tar.gz" :sha256 "d33a4fd24c72c2d08893f129d724adf725b93dae96c359e4f4e9f32573cc853b" :filename "inotify-tools-4.25.9.0.tar.gz"}
 :deps ["karate/glibc"]
 :build_deps ["karate/autoconf" "karate/automake" "karate/gcc" "karate/libtool" "karate/make"]
 :bin_dirs ["bin"]
 :build (fn [b]
          (b:run ["autoreconf" "--force" "--install"])
          (b.default.build b))}
