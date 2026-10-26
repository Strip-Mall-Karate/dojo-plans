;; traefik, ported from its plan.sh.
;; The source project's plan fetched traefik with `go get` and reset it to the
;; v1.7.7 tag, and fetched go-bindata at its newest commit. This is the tag's
;; archive, pinned (traefik vendors its Go dependencies), and go-bindata at its
;; last commit before the fork date (5 March 2018), pinned. The web UI's yarn
;; install fetches what its yarn.lock names. The scripts run with the bash this
;; plan depends on, which the source project's studio provided.
{:name "traefik"
 :origin "karate"
 :version "1.7.7"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["MIT"]
 :description "a modern reverse proxy"
 :upstream_url "https://traefik.io"
 :source {:url "https://github.com/containous/traefik/archive/v1.7.7.tar.gz" :sha256 "d83a7932e9d47f19e7540b1c67e1837b2a72618a57521072a6794317ef74d5c4" :filename "traefik-v1.7.7.tar.gz"}
 :build_deps ["karate/node6" "karate/sed" "karate/yarn" "karate/bash"]
 :scaffolding "karate/scaffolding-go"
 :bin_dirs ["bin"]
 :svc {:user "root" :group "root"}
 :exports {"web_port" "web.port" "web_host" "web.host" "web_enabled" "web.enable"}
 :download (fn [b]
             (b.default.download b)
             (b:download "https://github.com/jteeuwen/go-bindata/archive/6025e8de665b31fa74ab1a66f2cddd8c0abf887e.tar.gz"
                         "7b3e96c456c6efccc6f6aa10919fe66fa03eb5c6a6adc38241173f110aad38e4" "go-bindata-6025e8de.tar.gz"))
 :prepare (fn [b]
            (b.scaffolding.env b)
            (b:env "VERSION" (.. "v" b.version))
            (b:env "CODENAME" "maroilles")
            (let [dir (b:join (b.scaffolding.gopath b) "src/github.com/jteeuwen/go-bindata")]
              (b:remove dir)
              (b:mkdir dir)
              (b:run ["tar" "xf" (b:join b.cache "go-bindata-6025e8de.tar.gz") "--strip-components=1" "--no-same-owner"] {:cwd dir})
              (b:run ["go" "install" "github.com/jteeuwen/go-bindata/..."] {:cwd dir})))
 :build (fn [b]
          (b.scaffolding.env b)
          (let [node (b:path_for "karate/node6")
                dir (b.scaffolding.pkg_path b)
                webui (b:join dir "webui")]
            (b:env "PATH" (.. node "/bin:" (or (b:getenv "PATH") "")))
            (b:run ["yarn" "install"] {:cwd webui})
            ;; Each tool yarn installed runs with node6's node; a link to nothing (an
            ;; optional module that did not install) has no tool to fix.
            (each [_ t (ipairs (b:glob (b:join webui "node_modules/.bin") "*"))]
              (when (b:exists t)
                (b:fix_interpreter [(b:capture ["readlink" "--canonicalize" "--no-newline" t])] "karate/node6" "bin/node")))
            (b:run ["yarn" "run" "build"] {:cwd webui})
            (b:run ["bash" "script/generate"] {:cwd dir})
            (b:run ["bash" "script/binary"] {:cwd dir})))
 :install (fn [b]
            (b:copy (b:join (b.scaffolding.pkg_path b) "dist/traefik") (b:join b.prefix "bin/traefik")))}
