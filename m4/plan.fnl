;; m4, ported from its plan.sh.
{:name "m4"
 :origin "karate"
 :version "1.4.18"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["gplv3"]
 :description "GNU M4 is an implementation of the traditional Unix macro processor. It is mostly SVR4 compatible although it has some extensions (for example, handling more than 9 positional parameters to macros). GNU M4 also has built-in functions for including files, running shell commands, doing arithmetic, etc."
 :upstream_url "http://www.gnu.org/software/m4"
 :source {:url "http://ftp.gnu.org/gnu/m4/m4-1.4.18.tar.xz" :sha256 "f2c1e86ca0a404ff281631bdc8377638992744b175afb806e25871a24a934e07"}
 :deps ["karate/glibc"]
 :build_deps ["karate/coreutils" "karate/diffutils" "karate/patch" "karate/make" "karate/gcc" "karate/binutils"]
 :bin_dirs ["bin"]
 :prepare (fn [b]
          (var v-dynamic-linker "")
          (b:run ["patch" "-p1" "-i" (.. b.plan_dir "/fix-test-getopt-posix-with-glibc-2.26.patch")])
          (b:env "CFLAGS" (.. (or (b:getenv "CFLAGS") "") " -B" (b:path_for "binutils") "/bin/"))
          (b:log (.. "Updating CFLAGS=" (or (b:getenv "CFLAGS") "")))
          (set v-dynamic-linker (.. (b:path_for "glibc") "/lib/ld-linux-x86-64.so.2"))
          (b:env "LDFLAGS" (.. (or (b:getenv "LDFLAGS") "") " -Wl,--dynamic-linker=" v-dynamic-linker))
          (b:log (.. "Updating LDFLAGS=" (or (b:getenv "LDFLAGS") ""))))
 :check (fn [b]
          (let [text (b:read (b:join b.src "build-aux/update-copyright"))] (b:write (b:join b.src "build-aux/update-copyright") (pick-values 1 (string.gsub text "[^\n]+" (fn [l] (var line l) (set line (pick-values 1 (string.gsub line "copyright{" "copyright\\{" 1))) line)))))
          (b:run ["make" "check"]))}
