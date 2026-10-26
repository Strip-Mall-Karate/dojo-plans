;; goreplay, ported from its plan.sh.
{:name "goreplay"
 :origin "karate"
 :version "0.16.1"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["LGPL-3.0"]
 :description "GoReplay is an open-source tool for capturing and replaying live HTTP traffic into a test environment in order to continuously test your system with real data."
 :upstream_url "https://goreplay.org/"
 :source {:url "https://github.com/buger/goreplay/releases/download/v0.16.1/gor_0.16.1_x64.tar.gz" :sha256 "25587cd4c88b0608ac4004a3c7c9722e10a9086cfcc77d1fb26d9f07bd48d245" :filename "gor_0.16.1_x64.tar.gz"}
 :bin_dirs ["bin"]
 :unpack (fn [b]
          (b:mkdir (.. b.name "-" b.version))
          (b:run ["tar" "-xvf" "gor_0.16.1_x64.tar.gz" "--directory" (.. b.name "-" b.version)] {:cwd b.cache}))
 :build (fn [b]
          nil)
 :install (fn [b]
          (b:copy (b:join b.src "goreplay") (.. b.prefix "/bin/goreplay"))
          (b:chmod (.. b.prefix "/bin/goreplay") "755"))}
