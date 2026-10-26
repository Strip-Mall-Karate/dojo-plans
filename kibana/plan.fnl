;; kibana, ported from its plan.sh.
(fn use-dependency-path [b path replacement]
  ;; The source project's studio linked a dependency's tool to `path` for the
  ;; build. A Dojo build writes nothing outside itself, so the build's scripts
  ;; name the dependency's tool instead.
  (each [_ f (ipairs (b:find b.src "*"))]
    (let [name (: f :match "[^/]+$")]
      (when (and (or (: name :match "^configure") (: name :match "^Makefile") (: name :match "^ltmain")
                     (: name :match "%.in$") (: name :match "%.am$") (: name :match "%.ac$")
                     (: name :match "%.m4$") (: name :match "%.mk$") (: name :match "%.sh$")
                     (: name :match "%.pl$") (: name :match "%.py$"))
                 (not (b:exists (b:join f "."))))
        (let [text (b:read f)
              escaped (pick-values 1 (: path :gsub "[%^%$%(%)%%%.%[%]%*%+%-%?]" "%%%0"))
              (fixed n) (: text :gsub escaped (pick-values 1 (: replacement :gsub "%%" "%%%%")))]
          (when (> n 0) (b:write f fixed)))))))
{:name "kibana"
 :origin "karate"
 :version "6.1.0"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["Apache-2.0"]
 :description "Kibana is a browser based analytics and search dashboard for Elasticsearch."
 :upstream_url "https://www.elastic.co/products/kibana"
 :source {:url "https://github.com/elastic/kibana/archive/v6.1.0.tar.gz" :sha256 "3f9b9179bae432e45411f7b207578d8232ca2d6fc184a5780b6d696d6037b55a" :filename "kibana-6.1.0.tar.gz"}
 :deps ["karate/node"]
 :build_deps ["karate/cacerts" "karate/coreutils" "karate/gcc" "karate/git" "karate/make" "karate/node" "karate/python2"]
 :bin_dirs ["bin"]
 :exports {"port" "server.port"}
 :exposes ["port"]
 :binds_optional {"elasticsearch" ["http-port"]}
 :prepare (fn [b]
          (use-dependency-path b "/usr/bin/env" (b:path_for "coreutils" "bin/env"))
          (b:run ["git" "config" "--global" "http.sslCAInfo" (.. (b:path_for "cacerts") "/ssl/certs/cacert.pem")])
          (b:run ["npm" "config" "set" "progress=false"]))
 :build (fn [b]
          (b:run ["npm" "install"]))
 :install (fn [b]
          (each [_ p (ipairs (b:glob b.src "*"))] (b:copy p (b:join (.. b.prefix "/") (: p :match "[^/]+$"))))
          (b:remove (.. b.prefix "/config/")))
 :strip (fn [b]
          ;; From do_end.
          )}
