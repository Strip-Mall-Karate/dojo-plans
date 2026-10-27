;; jo, ported from its plan.sh.
{:name :jo
 :origin :karate
 :version :1.1
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:GPL-2.0]
 :description "jo, a small utility to create JSON objects."
 :upstream_url "https://github.com/jpmens/jo"
 :source {:url "https://github.com/jpmens/jo/releases/download/v1.1/jo-1.1.tar.gz"
          :sha256 :63ed4766c2e0fcb5391a14033930329369f437d7060a11d82874e57e278bda5f}
 :build_deps [:karate/linux-headers-musl
              :karate/musl
              :karate/make
              :karate/gcc
              :karate/diffutils]
 :bin_dirs [:bin]
 :prepare (fn [b]
            (b:env :CFLAGS
                   (.. :-I (b:path_for :linux-headers-musl) "/include -I"
                       (b:path_for :musl) :/include))
            (b:log (.. "Setting CFLAGS=" (or (b:getenv :CFLAGS) "")))
            (b:env :LDFLAGS (.. "-static " (or (b:getenv :LDFLAGS) "")))
            (b:log (.. "Setting LDFLAGS=" (or (b:getenv :LDFLAGS) "")))
            (b:env :CC :musl-gcc)
            (b:log (.. "Setting CC=" (or (b:getenv :CC) ""))))
 :check (fn [b]
          (b:run [:make :check]))}
