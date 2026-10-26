;; nano, ported from its plan.sh.
{:name "nano"
 :origin "karate"
 :version "2.9.8"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["GPL-3.0-or-later"]
 :description "GNU nano -- an enhanced clone of the Pico text editor."
 :upstream_url "https://www.nano-editor.org"
 :source {:url "https://www.nano-editor.org/dist/v2.9/nano-2.9.8.tar.xz" :sha256 "c2deac31ba4d3fd27a42fafcc47ccf499296cc69a422bbecab63f2933ea85488"}
 :deps ["karate/ncurses"]
 :build_deps ["karate/make" "karate/gcc"]
 :bin_dirs ["bin"]
 :build (fn [b]
          (b.default.build b)
          (b:copy (b:join b.src "COPYING") (.. b.prefix "/share/COPYING"))
          (b:chmod (.. b.prefix "/share/COPYING") "644"))}
