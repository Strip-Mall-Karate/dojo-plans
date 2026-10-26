;; mg, ported from its plan.sh.
;; mg 20260719, the latest release on 2026-10-26.
{:name "mg"
 :origin "karate"
 :version "20260719"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["publicdomain"]
 :description "mg is Micro GNU/emacs, this is a portable version of the mg maintained by the OpenBSD team."
 :upstream_url "https://homepage.boetes.org/software/mg/"
 :source {:url "https://github.com/hboetes/mg/archive/refs/tags/20260719.tar.gz" :sha256 "8ca736b1e57d9681e7921d37b9cf0282e3098e2929ed37384400c78dae54762d" :filename "mg-20260719.tar.gz"}
 :deps ["karate/glibc" "karate/ncurses" "karate/libbsd"]
 :build_deps ["karate/coreutils" "karate/diffutils" "karate/patch" "karate/make" "karate/gcc" "karate/sed" "karate/pkg-config"]
 :bin_dirs ["bin"]
 :build (fn [b]
          (b:run ["make" (.. "prefix=" b.prefix) "PKG_CONFIG=pkg-config" "INSTALL=install" "STRIP=strip"]))
 :install (fn [b]
          (b:run ["make" "install" (.. "prefix=" b.prefix) "PKG_CONFIG=pkg-config" "INSTALL=install" "STRIP=strip"])
          (b:mkdir (.. b.prefix "/share/licenses"))
          (b:copy (b:join b.src "README") (.. b.prefix "/share/licenses/README"))
          (b:chmod (.. b.prefix "/share/licenses/README") "644"))}
