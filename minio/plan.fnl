;; minio, ported from its plan.sh.
{:name :minio
 :origin :karate
 :version :2018-11-30T03-56-59Z
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:Apache-2.0]
 :description "Minio is a high performance distributed object storage server, designed for large-scale private cloud infrastructure."
 :upstream_url "https://minio.io"
 :source {:url "https://dl.minio.io/server/minio/release/linux-amd64/archive/minio.RELEASE.2018-11-30T03-56-59Z"
          :sha256 :cbb86818efa9f281195334e37cebc8aa014a41cd20173216617c2267b0d71ec3}
 :bin_dirs [:bin]
 :unpack (fn [b]
           nil)
 :build (fn [b]
          nil)
 :install (fn [b]
            (b:mkdir (.. b.prefix :/bin))
            (if (b:exists (.. b.prefix :/bin/minio))
                (b:copy (b:join b.src (.. :../minio.RELEASE. b.version))
                        (b:join (.. b.prefix :/bin/minio)
                                (: (b:join b.src
                                           (.. :../minio.RELEASE. b.version))
                                   :match "[^/]+$")))
                (b:copy (b:join b.src (.. :../minio.RELEASE. b.version))
                        (.. b.prefix :/bin/minio)))
            (b:chmod (.. b.prefix :/bin/minio) :+x))
 :strip (fn [b]
          nil)}
