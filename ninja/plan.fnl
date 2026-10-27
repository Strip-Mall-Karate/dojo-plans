;; ninja, ported from its plan.sh.
;; ninja 1.13.2, the latest release on 2026-10-27, bootstrapped with Python 3.
{:name "ninja"
 :origin "karate"
 :version "1.13.2"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :description "A small build system with a focus on speed"
 :upstream_url "https://ninja-build.org/"
 :source {:url "https://github.com/ninja-build/ninja/archive/v1.13.2.tar.gz" :sha256 "974d6b2f4eeefa25625d34da3cb36bdcebe7fbce40f4c16ac0835fd1c0cbae17" :filename "ninja-1.13.2.tar.gz"}
 :deps ["karate/glibc" "karate/gcc-libs"]
 :build_deps ["karate/gcc" "karate/python" "karate/re2c"]
 :bin_dirs ["bin"]
 :build (fn [b]
          (b:run ["python3" "configure.py" "--bootstrap"]))
 :install (fn [b]
            (b:mkdir (.. b.prefix "/bin/"))
            (b:copy (b:join b.src "ninja") (.. b.prefix "/bin/ninja")))}
