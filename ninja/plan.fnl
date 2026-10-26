;; ninja, ported from its plan.sh.
{:name "ninja"
 :origin "karate"
 :version "1.8.2"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :description "A small build system with a focus on speed"
 :upstream_url "https://ninja-build.org/"
 :source {:url "https://github.com/ninja-build/ninja/archive/v1.8.2.tar.gz" :sha256 "86b8700c3d0880c2b44c2ff67ce42774aaf8c28cbf57725cb881569288c1c6f4"}
 :deps ["karate/glibc" "karate/gcc-libs"]
 :build_deps ["karate/gcc" "karate/python2" "karate/re2c"]
 :bin_dirs ["bin"]
 :build (fn [b]
          (b:run ["python" "configure.py" "--bootstrap"]))
 :check (fn [b]
          (b:run ["./ninja" "all"])
          (b:run ["./ninja_test" "--gtest_filter=-SubprocessTest.SetWithLots"])
          (b:run ["python" "./misc/ninja_syntax_test.py"]))
 :install (fn [b]
          (b:mkdir (.. b.prefix "/bin/"))
          (b:copy (b:join b.src "ninja") (b:join (.. b.prefix "/bin/") (: (b:join b.src "ninja") :match "[^/]+$"))))}
