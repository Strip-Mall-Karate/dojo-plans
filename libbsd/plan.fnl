;; libbsd, ported from its plan.sh.
;; libbsd 0.12.2, the latest release on 2026-10-26.
{:name "libbsd"
 :origin "karate"
 :version "0.12.2"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["custom"]
 :description "This library provides useful functions commonly found on BSD systems, and lacking on others like GNU systems"
 :upstream_url "https://libbsd.freedesktop.org/wiki/"
 :source {:url "https://libbsd.freedesktop.org/releases/libbsd-0.12.2.tar.xz" :sha256 "b88cc9163d0c652aaf39a99991d974ddba1c3a9711db8f1b5838af2a14731014"}
 :deps ["karate/glibc" "karate/libmd"]
 :build_deps ["karate/coreutils" "karate/diffutils" "karate/file" "karate/gcc" "karate/make" "karate/patch" "karate/pkg-config" "karate/sed"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :pconfig_dirs ["lib/pkgconfig"]
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
