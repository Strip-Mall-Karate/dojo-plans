;; shellcheck, ported from its plan.sh.
;; The plan's do_clean is not ported: a build empties its source directory before
;; unpacking and starts with no state from an earlier one.
{:name "shellcheck"
 :origin "karate"
 :version "0.6.0"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["GPL-3"]
 :description "ShellCheck is a GPLv3 tool that gives warnings and suggestions for bash/sh shell scripts"
 :upstream_url "http://www.shellcheck.net/"
 :source {:url "https://hackage.haskell.org/package/ShellCheck-0.6.0/ShellCheck-0.6.0.tar.gz" :sha256 "f6e79fb34d076504176761cc8b7c3f996f8d31bed23250fb1570e32283cd7df6" :dirname "ShellCheck-0.6.0"}
 :deps ["karate/glibc" "karate/gmp" "karate/libffi"]
 :build_deps ["karate/cabal-install" "karate/ghc"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :build (fn [b]
          (b:run ["cabal" "v1-sandbox" "init"])
          (b:run ["cabal" "v1-update"])
          (b:run ["cabal" "v1-install" "--only-dependencies"])
          (b:run ["cabal" "v1-configure" (.. "--prefix=" b.prefix) "--disable-executable-dynamic" "--disable-shared"])
          (b:run ["cabal" "v1-build"]))
 :check (fn [b]
          (b:run ["cabal" "v1-test"]))
 :install (fn [b]
          (b:run ["cabal" "v1-copy"]))}
