;; htop, ported from its plan.sh.
{:name :htop
 :origin :karate
 :version :2.0.1
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:GPL-2.0]
 :description "This is htop, an interactive process viewer for Unix systems. It is a text-mode application (for console or X terminals) and requires ncurses."
 :upstream_url "http://hisham.hm/htop/"
 :source {:url "http://hisham.hm/htop/releases/2.0.1/htop-2.0.1.tar.gz"
          :sha256 :f410626dfaf6b70fdf73cd7bb33cae768869707028d847fed94a978e974f5666}
 :deps [:karate/glibc :karate/ncurses]
 :build_deps [:karate/gcc :karate/make]
 :bin_dirs [:bin]
 :check (fn [b]
          (b:run [:make :test]))}
