;; prometheus, ported from its plan.sh.
{:name :prometheus
 :origin :karate
 :version :2.7.1
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:Apache-2.0]
 :description "Prometheus monitoring"
 :upstream_url "http://prometheus.io"
 :source {:url "https://github.com/prometheus/prometheus/archive/v2.7.1.tar.gz"
          :sha256 :fe239e23379ce6d50c5577f515d7f576f1c6f9396ea47fd87c08fbf8b5e163fb}
 :build_deps [:karate/go :karate/git :karate/gcc :karate/make]
 :bin_dirs [:bin]
 :exports {:prom_ds_http :listening_port}
 :exposes [:prom_ds_http]
 :binds_optional {:targets [:metric-http-port]}
 :unpack (fn [b]
           (b:mkdir (.. b.cache :/prometheus-2.7.1
                        :/src/github.com/prometheus/prometheus))
           (b:run [:tar
                   :xf
                   (.. b.cache :/v2.7.1.tar.gz)
                   :--strip
                   :1
                   :--no-same-owner]
                  {:cwd (.. b.cache :/prometheus-2.7.1
                            :/src/github.com/prometheus/prometheus)}))
 :prepare (fn [b]
            ;; From do_setup_environment.
            (b:env :GOPATH (.. b.cache "/" b.name "-" b.version))
            (b.default.prepare b))
 :build (fn [b]
          (b:run [:make :build]
                 {:cwd (.. b.cache :/prometheus-2.7.1
                           :/src/github.com/prometheus/prometheus)
                  :env {:USER :root :PREFIX (.. b.prefix :/bin)}}))
 :check (fn [b]
          (b:run [:make :test]
                 {:cwd (.. b.cache :/prometheus-2.7.1
                           :/src/github.com/prometheus/prometheus)}))
 :install (fn [_b]
            nil)}
