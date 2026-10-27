;; ncdu, ported from its plan.sh.
{:name :ncdu
 :origin :karate
 :version :1.11
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:MIT]
 :description "Ncdu is a disk usage analyzer with an ncurses interface"
 :upstream_url "https://dev.yorhel.nl/ncdu"
 :source {:url "https://dev.yorhel.nl/download/ncdu-1.11.tar.gz"
          :sha256 :d0aea772e47463c281007f279a9041252155a2b2349b18adb9055075e141bb7b}
 :deps [:karate/glibc :karate/ncurses]
 :build_deps [:karate/coreutils :karate/gcc :karate/make]
 :bin_dirs [:bin]}
