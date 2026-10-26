;; coreutils-static, ported from its plan.sh.
;; Built from the coreutils plan, with its own changes.
(fn v--patch-files [b]
  (b:run ["patch" "-p1" "-i" (.. b.plan_dir "/skip-tests.patch")]))
{:name "coreutils-static"
 :origin "karate"
 :version "8.30"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["GPL-3.0"]
 :description "The GNU Core Utilities are the basic file, shell and text manipulation utilities of the GNU operating system. These are the core utilities which are expected to exist on every operating system."
 :upstream_url "https://www.gnu.org/software/coreutils/"
 :source {:url "http://ftp.gnu.org/gnu/coreutils/coreutils-8.30.tar.xz" :sha256 "e831b3a86091496cdba720411f9748de81507798f6130adeaef872d206e1b057" :dirname "coreutils-8.30"}
 :build_deps ["karate/glibc" "karate/acl" "karate/attr" "karate/gmp" "karate/libcap" "karate/coreutils" "karate/diffutils" "karate/patch" "karate/make" "karate/gcc" "karate/m4" "karate/perl" "karate/inetutils"]
 :bin_dirs ["bin"]
 :interpreters ["bin/env"]
 :prepare (fn [b]
          ;; coreutils' own patch, applied as its _patch_files did.
          (b:run ["patch" "-p1" "-i" (.. b.plan_dir "/../coreutils/skip-tests.patch")]))
 :build (fn [b]
          (b:run ["./configure" (.. "--prefix=" b.prefix) "--enable-single-binary" (.. "LDFLAGS=-static " (or (b:getenv "LDFLAGS") ""))] {:env {"FORCE_UNSAFE_CONFIGURE" "1"}})
          (b:run ["make"]))}
