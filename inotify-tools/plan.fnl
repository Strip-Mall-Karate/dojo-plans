;; inotify-tools, ported from its plan.sh.
{:name "inotify-tools"
 :origin "karate"
 :version "3.14"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["GPL-2.0"]
 :description "inotify-tools is a C library and a set of command-line programs for Linux providing a simple interface to inotify. These programs can be used to monitor and act upon filesystem events."
 :upstream_url "https://github.com/rvoicilas/inotify-tools/wiki"
 :source {:url "http://github.com/downloads/rvoicilas/inotify-tools/inotify-tools-3.14.tar.gz" :sha256 "222bcca8893d7bf8a1ce207fb39ceead5233b5015623d099392e95197676c92f"}
 :deps ["karate/glibc"]
 :build_deps ["karate/gcc" "karate/make"]
 :bin_dirs ["bin"]}
