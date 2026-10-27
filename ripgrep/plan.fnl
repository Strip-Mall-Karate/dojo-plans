;; ripgrep, ported from its plan.sh.
{:name :ripgrep
 :origin :karate
 :version :0.5.2
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:MIT :Unlicense]
 :description "ripgrep combines the usability of The Silver Searcher with the raw speed of grep."
 :upstream_url "https://github.com/BurntSushi/ripgrep"
 :source {:url "https://github.com/BurntSushi/ripgrep/releases/download/0.5.2/ripgrep-0.5.2-x86_64-unknown-linux-musl.tar.gz"
          :sha256 :ecb53ed7e9f3a1ebea76a4e517af42ffe1e778eab3b413200a3e543d033f68f5
          :dirname :ripgrep-0.5.2-x86_64-unknown-linux-musl}
 :bin_dirs [:bin]
 :build (fn [b]
          nil)
 :install (fn [b]
            (b:copy (.. b.src :/rg) (.. b.prefix :/bin/rg))
            (b:chmod (.. b.prefix :/bin/rg) :0755))
 :strip (fn [b]
          nil)}
