;; tmux, ported from its plan.sh.
{:name :tmux
 :origin :karate
 :version :2.7
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:MIT]
 :description "A terminal multiplexer"
 :upstream_url "https://tmux.github.io/"
 :source {:url "https://github.com/tmux/tmux/releases/download/2.7/tmux-2.7.tar.gz"
          :sha256 :9ded7d100313f6bc5a87404a4048b3745d61f2332f99ec1400a7c4ed9485d452}
 :deps [:karate/glibc :karate/libevent :karate/ncurses]
 :build_deps [:karate/gcc :karate/make]
 :bin_dirs [:bin]}
