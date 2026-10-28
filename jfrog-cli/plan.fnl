;; jfrog-cli, ported from its plan.sh.
(fn v-cgo-wrap-binary [b a1]
  (var v-bin "")
  (var v-certs "")
  (set v-bin (.. b.prefix :/bin/ a1))
  (b:log (.. "Adding wrapper " v-bin " to " v-bin :.real))
  (if (b:exists (.. v-bin :.real))
      (b:move v-bin (b:join (.. v-bin :.real) (v-bin:match "[^/]+$")))
      (b:move v-bin (.. v-bin :.real)))
  (set v-certs (.. (b:path_for :cacerts) :/ssl/cert.pem))
  (b:write v-bin
           (.. "#!" (b:path_for :busybox-static) "/bin/sh
set -e
if [ ! -f \"/etc/ssl/certs/ca-certificates.crt\" ]; then
  echo \"Adding symlink of "
               v-certs " under /etc\"\n  mkdir -p /etc/ssl/certs\n  ln -snf "
               v-certs " /etc/ssl/certs/ca-certificates.crt
fi
export LD_LIBRARY_PATH=\""
               (or (b:getenv :LD_RUN_PATH) "") "\"\nexec " (b:path_for :glibc)
               "/lib/ld-linux-x86-64.so.2 " v-bin ".real $@\n"))
  (b:chmod v-bin :755))

{:name :jfrog-cli
 :origin :karate
 :version :1.7.1
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:apachev2]
 :description "jfrog CLI"
 :upstream_url "https://github.com/JFrogDev/jfrog-cli-go"
 :source {:url "https://jfrog.bintray.com/jfrog-cli-go/1.7.1/jfrog-cli-linux-amd64/jfrog"
          :sha256 :172afbfe482c48bea347318bd27ad4ac3d2f2d6a152aa51e1ca94629faff7e6c}
 :deps [:karate/glibc :karate/busybox-static :karate/cacerts]
 :build_deps [:karate/coreutils]
 :bin_dirs [:bin]
 :unpack (fn [_b]
           nil)
 :build (fn [_b]
          nil)
 :install (fn [b]
            (b:copy (.. b.cache :/jfrog) (.. b.prefix :/bin/jfrog))
            (b:chmod (.. b.prefix :/bin/jfrog) :755)
            (v-cgo-wrap-binary b :jfrog))}
