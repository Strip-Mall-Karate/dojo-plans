;; exercism, ported from its plan.sh.
{:name :exercism
 :origin :karate
 :version :3.0.11
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:MIT]
 :description "A Go based command line tool for exercism.io."
 :upstream_url "http://exercism.io/"
 :source {:url "https://github.com/exercism/cli/releases/download/v3.0.11/exercism-linux-64bit.tgz"
          :sha256 :bf0a55abc27cbdcfcc1cba4336eafdec3486b2434b96017b75d54ec8fc7a3360}
 :bin_dirs [:bin]
 :build (fn [_b]
          nil)
 :install (fn [b]
            (b:copy (.. b.cache "/" b.name) (.. b.prefix :/bin/ b.name))
            (b:chmod (.. b.prefix :/bin/ b.name) :0755))
 :strip (fn [_b]
          nil)}
