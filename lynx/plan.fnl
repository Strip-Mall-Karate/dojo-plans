;; lynx, ported from its plan.sh.
{:name "lynx"
 :origin "karate"
 :version "2.8.8"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["GPL-2.0"]
 :description "Lynx is the text web browser."
 :upstream_url "http://lynx.browser.org/"
 :source {:url "http://invisible-mirror.net/archives/lynx/tarballs/lynx2.8.8rel.2.tar.gz" :sha256 "234c9dc77d4c4594ad6216d7df4d49eae3019a3880e602f39721b35b97fbc408" :dirname "lynx2-8-8"}
 :deps ["karate/glibc" "karate/ncurses"]
 :build_deps ["karate/gcc" "karate/make" "karate/patch"]
 :bin_dirs ["bin"]
 :prepare (fn [b]
          (b:run ["patch" "-p1" "-i" (.. b.plan_dir "/ncurses.patch")]))
 :check (fn [b]
          (b:run ["make" "test"]))}
