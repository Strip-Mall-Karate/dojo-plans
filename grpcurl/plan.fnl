;; grpcurl, ported from its plan.sh.
;; The source project's plan fetched grpcurl and its dependencies with `go get`
;; (each at its newest commit) and reset grpcurl to the v1.1.0 tag. This is that
;; tag's archive, pinned, built in module mode: its dependencies are the
;; versions its go.mod names, checked against its go.sum. Its Makefile stamps the
;; version git describes, which an archive cannot; that is v1.1.0.
{:name :grpcurl
 :origin :karate
 :version :1.1.0
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:MIT]
 :description "Like cURL, but for gRPC: Command-line tool for interacting with gRPC servers"
 :upstream_url "https://github.com/fullstorydev/grpcurl"
 :source {:url "https://github.com/fullstorydev/grpcurl/archive/v1.1.0.tar.gz"
          :sha256 :8c8af1643c4d549947a2f2198f5c21d634b2a24b31de975a5784841a9127c82f
          :filename :grpcurl-v1.1.0.tar.gz}
 :scaffolding :karate/scaffolding-go
 :bin_dirs [:bin]
 :build (fn [b]
          (b.scaffolding.env b)
          (b:run [:make :install :dev_build_version=v1.1.0]
                 {:cwd (b.scaffolding.pkg_path b) :env {:GO111MODULE :on}}))
 :install (fn [b]
            (b:copy (b:join (b.scaffolding.gopath b) :bin/grpcurl)
                    (b:join b.prefix :bin/grpcurl)))}
