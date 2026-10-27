;; img, ported from its plan.sh.
;; The source project's plan cloned img's default branch, unverified, whatever
;; its version said. This is the v0.5.4 tag's archive, pinned, unpacked where its
;; GOPATH expects it.
{:name :img
 :origin :karate
 :version :0.5.4
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:MIT]
 :description "Standalone, daemon-less, unprivileged Dockerfile and OCI compatible container image builder."
 :upstream_url "https://github.com/genuinetools/img"
 :source {:url "https://github.com/genuinetools/img/archive/v0.5.4.tar.gz"
          :sha256 :850ba1df034dc86d67ca37a6c5a9c2a7d8b6e523f5b96ae5d03692fca3df8ec5
          :filename :img-0.5.4.tar.gz
          :dirname :go/src/github.com/genuinetools/img}
 :deps [:karate/git :karate/pkg-config :karate/libseccomp]
 :build_deps [:karate/go :karate/git :karate/dep :karate/make :karate/gcc]
 :bin_dirs [:bin]
 :unpack (fn [b]
           (b:remove b.src)
           (b:mkdir b.src)
           (b:run [:tar
                   :xf
                   (b:join b.cache :img-0.5.4.tar.gz)
                   :--strip-components=1] {:cwd b.src}))
 :build (fn [b]
          (b:env :GOPATH (.. b.cache :/go))
          (b:env :PATH (.. (or (b:getenv :PATH) "") ":" b.cache :/go/bin))
          (b:run [:make :static]))
 :install (fn [b]
            (b:mkdir (.. b.prefix :/bin))
            (b:copy (b:join b.src :img) (.. b.prefix :/bin/img)))}
