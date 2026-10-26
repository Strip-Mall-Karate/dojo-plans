;; prometheus1, ported from its plan.sh.
;; Built from the prometheus plan, with its own changes.
{:name "prometheus1"
 :origin "karate"
 :version "1.6.1"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["Apache-2.0"]
 :description "Prometheus monitoring"
 :upstream_url "http://prometheus.io"
 :source {:url "https://github.com/prometheus/prometheus/archive/v1.6.1.tar.gz" :sha256 "ecc9ce94fce45994c23b76eb0c5acbb1b942513be601872c8cd74d0821450c5e"}
 :build_deps ["karate/go" "karate/git" "karate/gcc" "karate/make"]
 :bin_dirs ["bin"]
 :exports {"prom_ds_http" "listening_port"}
 :exposes ["prom_ds_http"]
 :binds_optional {"targets" ["metric-http-port"]}
 :unpack (fn [b]
          (b:mkdir (b:join b.src "@{cache}/prometheus1-1.6.1/src/github.com/prometheus/prometheus"))
          (b:run ["tar" "xf" (.. b.cache "/v1.6.1.tar.gz") "--strip" "1" "--no-same-owner"] {:cwd "@{cache}/prometheus1-1.6.1/src/github.com/prometheus/prometheus"}))
 :prepare (fn [b]
          ;; From do_setup_environment.
          (b:env "GOPATH" (.. b.cache "/" (.. b.name "-" b.version)))
          (b.default.prepare b))
 :build (fn [b]
          (b:run ["make" "build"] {:cwd "@{cache}/prometheus1-1.6.1/src/github.com/prometheus/prometheus" :env {"USER" "root" "PREFIX" (.. b.prefix "/bin")}}))
 :check (fn [b]
          (b:run ["make" "test"] {:cwd "@{cache}/prometheus1-1.6.1/src/github.com/prometheus/prometheus"}))
 :install (fn [b]
          nil)}
