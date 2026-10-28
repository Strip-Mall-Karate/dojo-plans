;; jq-static, ported from its plan.sh.
{:name :jq-static
 :origin :karate
 :version :1.5
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:mit]
 :source {:url "https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64"
          :sha256 :c6b3a7d7d3e7b70c6f51b706a3b90bd01833846c54d32ca32f0027f00226ff6d}
 :build_deps [:karate/coreutils :karate/wget]
 :bin_dirs [:bin]
 :unpack (fn [_b]
           nil)
 :build (fn [_b]
          nil)
 :install (fn [b]
            (b:copy (.. b.cache :/jq-linux64) (.. b.prefix :/bin/jq))
            (b:chmod (.. b.prefix :/bin/jq) :755))}
