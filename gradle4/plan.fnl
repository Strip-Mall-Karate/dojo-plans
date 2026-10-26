;; gradle4, ported from its plan.sh.
;; Built from the gradle plan, with its own changes.
{:name "gradle4"
 :origin "karate"
 :version "4.10.3"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["Apache-2.0"]
 :description "A powerful build system for the JVM"
 :upstream_url "http://gradle.org"
 :source {:url "https://services.gradle.org/distributions/gradle-4.10.3-bin.zip" :sha256 "8626cbf206b4e201ade7b87779090690447054bc93f052954c78480fa6ed186e" :dirname "gradle-4.10.3"}
 :deps ["karate/glibc" "karate/corretto8" "karate/coreutils" "karate/bash-static" "karate/gcc-libs" "karate/sed"]
 :build_deps ["karate/make" "karate/gcc" "karate/corretto8" "karate/patchelf"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :build (fn [b]
          (b:mkdir (b:join b.src "patching"))
          (b:run ["jar" "xf" "../lib/native-platform-linux-amd64-0.14.jar"] {:cwd "patching"})
          (b:run ["patchelf" "--set-rpath" (or (b:getenv "LD_RUN_PATH") "") "net/rubygrapefruit/platform/linux-amd64/libnative-platform.so"] {:cwd "patching"})
          (b:run ["jar" "cf" "native-platform-linux-amd64-0.14.jar" "."] {:cwd "patching"})
          (b:move (b:join (b:join b.src "patching") "native-platform-linux-amd64-0.14.jar") (b:join (b:join (b:join b.src "patching") "../lib/") (: (b:join (b:join b.src "patching") "native-platform-linux-amd64-0.14.jar") :match "[^/]+$")))
          (b:remove (b:join b.src "patching"))
          (b:fix_interpreter [(b:join b.src "bin/gradle")] "karate/coreutils" "bin/env"))
 :install (fn [b]
          (if (b:exists b.prefix)
            (b:copy b.src (b:join b.prefix (: b.src :match "[^/]+$")))
            (b:copy b.src b.prefix)))
 :strip (fn [b]
          nil)}
