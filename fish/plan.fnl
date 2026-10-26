;; fish, ported from its plan.sh.
{:name "fish"
 :origin "karate"
 :version "2.5.0"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["GPL-2.0" "LGPL-2.0" "ISC" "BSD-2-Clause-NetBSD" "BSD-3-Clause"]
 :description "fish is a smart and user-friendly command line shell for macOS, Linux, and the rest of the family."
 :upstream_url "https://fishshell.com/"
 :source {:url "https://github.com/fish-shell/fish-shell/releases/download/2.5.0/fish-2.5.0.tar.gz" :sha256 "f8c0edadca2de379ccf305aeace660a9255fa2180c72e85e97705a24c256b2a5"}
 :deps ["karate/bc" "karate/coreutils" "karate/gawk" "karate/gcc-libs" "karate/glibc" "karate/grep" "karate/man-db" "karate/ncurses" "karate/net-tools"]
 :build_deps ["karate/gcc" "karate/make"]
 :bin_dirs ["bin"]
 :pconfig_dirs ["share/pkgconfig"]
 :interpreters ["bin/fish"]}
