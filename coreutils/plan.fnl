;; coreutils, ported from its plan.sh.
;; coreutils 9.12, the latest release on 2026-10-26.
(fn v--patch-files [b]
  (b:run ["patch" "-p1" "-i" (.. b.plan_dir "/skip-tests.patch")]))
{:name "coreutils"
 :origin "karate"
 :version "9.12"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["GPL-3.0"]
 :description "The GNU Core Utilities are the basic file, shell and text manipulation utilities of the GNU operating system. These are the core utilities which are expected to exist on every operating system."
 :upstream_url "https://www.gnu.org/software/coreutils/"
 :source {:url "https://ftp.gnu.org/gnu/coreutils/coreutils-9.12.tar.xz" :sha256 "a480198559733e9b3da999e90543ac6f888a2caa544d8d664c5a1f17e528e210"}
 :deps ["karate/glibc" "karate/acl" "karate/attr" "karate/gmp" "karate/libcap"]
 :build_deps ["karate/coreutils" "karate/diffutils" "karate/patch" "karate/make" "karate/gcc" "karate/m4" "karate/perl" "karate/inetutils"]
 :bin_dirs ["bin"]
 :interpreters ["bin/env"]
 :prepare (fn [b]
          (v--patch-files b))
 :build (fn [b]
          (b:run ["./configure" (.. "--prefix=" b.prefix) "--enable-no-install-program=kill,uptime"] {:env {"FORCE_UNSAFE_CONFIGURE" "1"}})
          (b:run ["make"]))
 :check (fn [b]
          (b:run ["make" "NON_ROOT_USERNAME=nobody" "check-root"])
          (b:run ["make" "RUN_EXPENSIVE_TESTS=yes" "check"]))}
