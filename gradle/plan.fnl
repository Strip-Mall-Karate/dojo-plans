;; gradle, ported from its plan.sh.
{:name "gradle"
 :origin "karate"
 :version "5.1"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["Apache-2.0"]
 :description "A powerful build system for the JVM"
 :upstream_url "http://gradle.org"
 :source {:url "https://services.gradle.org/distributions/gradle-5.1-bin.zip" :sha256 "7506638a380092a0406364c79d6c87d03d23017fc25a5770379d1ce23c3fcd4d"}
 :deps ["karate/glibc" "karate/jre8" "karate/coreutils" "karate/bash-static" "karate/gcc-libs" "karate/sed"]
 :build_deps ["karate/make" "karate/gcc" "karate/jdk8" "karate/patchelf"]
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
