;; libbsd, ported from its plan.sh.
{:name "libbsd"
 :origin "karate"
 :version "0.9.1"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["custom"]
 :description "This library provides useful functions commonly found on BSD systems, and lacking on others like GNU systems"
 :upstream_url "https://libbsd.freedesktop.org/wiki/"
 :source {:url "https://libbsd.freedesktop.org/releases/libbsd-0.9.1.tar.xz" :sha256 "56d835742327d69faccd16955a60b6dcf30684a8da518c4eca0ac713b9e0a7a4"}
 :deps ["karate/glibc"]
 :build_deps ["karate/coreutils" "karate/diffutils" "karate/file" "karate/gcc" "karate/make" "karate/patch" "karate/pkg-config" "karate/sed"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :pconfig_dirs ["lib/pkgconfig"]
 :prepare (fn [b]
          (when (not (b:exists "/usr/bin/file"))
            (b:symlink (.. (b:path_for "karate/file") "/bin/file") "/usr/bin/file") (var v--clean-file "true")))
 :check (fn [b]
          (b:run ["make" "check"]))
 :install (fn [b]
          (b.default.install b)
          (b:copy (b:join b.src "COPYING") (.. b.prefix "/share/licenses/LICENSE"))
          (b:chmod (.. b.prefix "/share/licenses/LICENSE") "644"))
 :strip (fn [b]
          (b.default.strip b)
          ;; From do_end.
          )}
