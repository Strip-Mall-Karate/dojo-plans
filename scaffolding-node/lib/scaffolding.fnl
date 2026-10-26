;; Scaffolding for Node.js applications.
;;
;; A plan using it has no source: its directory's package.json describes the
;; application. The scaffolding detects the package manager (npm, or yarn when
;; there is a yarn.lock), the Node package (package.json's engines.node, else
;; .nvmrc, else karate/node) and the processes to run (the Procfile, and
;; scripts.start as `web`), installs the dependencies, and packages the app
;; under app/ with a bin per process. Settings, in the plan's
;; `:scaffolding {:settings ...}`:
;;
;;   :pkg_manager    "npm" or "yarn", instead of detecting it
;;   :node_pkg       the Node package, instead of detecting it
;;   :app_port       the app's port in default.toml (8000)
;;   :env            more variables for the app's environment, name to value
;;   :process_bins   more processes, name to command; they win over detected ones

(local app-prefix "app")

;; The Node packages this repository builds, by version, oldest first: an
;; engines.node constraint picks the newest that meets it.
(local node-versions [["6.14.4" "karate/node6"]
                      ["8.15.0" "karate/node8"]
                      ["9.0.0" "karate/node9"]
                      ["10.15.2" "karate/node10"]
                      ["11.13.0" "karate/node"]])

(fn trim [s]
  (or (s:match "^%s*(.-)%s*$") ""))

(fn split-version [v]
  ;; "8" is 8.0.0 and "8.1" is 8.1.0; a `*` part counts as 0.
  (let [parts (icollect [part (v:gmatch "[^.]+")]
                (or (tonumber (part:match "^%d+")) 0))]
    [(or (. parts 1) 0) (or (. parts 2) 0) (or (. parts 3) 0)]))

(fn compare [a b]
  (let [x (split-version a)
        y (split-version b)]
    (var result 0)
    (for [i 1 3]
      (when (= result 0)
        (set result (if (< (. x i) (. y i)) -1 (> (. x i) (. y i)) 1 0))))
    result))

(fn nearest-node [constraint]
  ;; The source project's rule: `=V`, `V`, `>=V` or `<=V` against each known
  ;; version, keeping the last (newest) that meets it.
  (when (not (constraint:match "^[<>=v]*[%d.%*]+$"))
    (error (.. "engines.node `" constraint "`: incompatible version string")))
  (let [op (or (constraint:match "^([<>]?=?)%d") "")
        version (constraint:match "([%d][%d.%*]*)$")]
    (var found nil)
    (each [_ [known ident] (ipairs node-versions)]
      (let [c (compare known version)
            meets (match op
                    "" (= c 0)
                    "=" (= c 0)
                    ">=" (>= c 0)
                    "<=" (<= c 0)
                    ">" (> c 0)
                    "<" (< c 0)
                    _ false)]
        (when meets (set found ident))))
    (or found (error (.. "engines.node `" constraint "`: no Node package in karate meets it")))))

(fn detect [read json settings]
  ;; What the application's files say, read through `read` and `json` (paths
  ;; in its directory).
  (let [package (json "package.json")
        _ (when (not package)
            (error "Node Scaffolding cannot find package.json in the root directory."))
        has (fn [path] (not= nil (read path)))
        _ (when (and (has "package-lock.json") (has "yarn.lock"))
            (error "Both a package-lock.json and yarn.lock are present. We only can only suppport one .lock file."))
        pkg-manager (if settings.pkg_manager
                        (do
                          (when (and (not= settings.pkg_manager "npm") (not= settings.pkg_manager "yarn"))
                            (error "Setting 'pkg_manager' can only be 'npm', 'yarn', or unset."))
                          settings.pkg_manager)
                        (has "package-lock.json") "npm"
                        (has "yarn.lock") "yarn"
                        "npm")
        bins {}
        set-if-unset (fn [name cmd] (when (= nil (. bins name)) (tset bins name cmd)))]
    (each [name cmd (pairs (or settings.process_bins {}))]
      (tset bins name cmd))
    (let [procfile (read "Procfile")]
      (when procfile
        (each [line (procfile:gmatch "[^\n]+")]
          (when (not (line:match "^#"))
            (let [(name cmd) (line:match "^([^:]*):(.*)$")]
              (when name (set-if-unset (trim name) (trim cmd))))))))
    (let [start (and package.scripts package.scripts.start)]
      (when (and start (not= start ""))
        (set-if-unset "web" (trim start))))
    (set-if-unset "sh" "sh")
    (let [engines (and package.engines package.engines.node)
          nvmrc (let [text (read ".nvmrc")] (and text (not= (trim text) "") (trim text)))
          node (or settings.node_pkg
                   (and engines (not= engines "") (nearest-node engines))
                   (and nvmrc (.. "karate/node/" nvmrc))
                   "karate/node")]
      {:package package :pkg-manager pkg-manager :bins bins :node node})))

(fn app-env [settings]
  (let [env {:PORT "{{cfg.app.port}}" :NODE_ENV "{{cfg.node_env}}"}]
    (each [name value (pairs (or settings.env {}))]
      (tset env name value))
    env))

(fn settings-of [b]
  (or b.scaffolding_settings {}))

(fn work [b]
  ;; Where dependencies are installed, apart from the application's directory.
  (b:join b.cache (.. b.name "-" b.version)))

;; What `metadata` detected when the plan loaded; the module stays loaded for
;; the build's phases.
(var detected nil)

(fn found [b]
  (or detected (error "scaffolding-node: the plan's metadata was not read")))

(fn toml-has [text key]
  ;; Whether default.toml sets `key` (a top-level key, a table, or table.key).
  (let [(table field) (key:match "^([^.]+)%.(.+)$")]
    (var section nil)
    (var hit false)
    (each [line (text:gmatch "[^\n]+")]
      (let [header (line:match "^%s*%[%s*([^%]]-)%s*%]")]
        (if header
            (do
              (set section header)
              (when (and (not table) (= header key)) (set hit true)))
            (let [name (line:match "^%s*([%w_%-]+)%s*=")]
              (when name
                (if table
                    (when (and (= section table) (= name field)) (set hit true))
                    (when (and (= section nil) (= name key)) (set hit true))))))))
    hit))

(fn process-bin [b bin cmd]
  (let [svc (.. "/doj/svc/" b.name)
        env-sh (.. svc "/config/app_env.sh")
        path (b:join b.prefix "bin" (.. b.name "-" bin))]
    (b:log (.. "Creating " path " process bin"))
    (b:write path (.. "#!" (b:path_for "karate/busybox-static") "/bin/sh\n"
                      "set -e\n"
                      "if test -n \"$DEBUG\"; then set -x; fi\n\n"
                      "export HOME=\"" svc "/data\"\n\n"
                      "if [ -f \"" env-sh "\" ]; then\n"
                      "  . \"" env-sh "\"\n"
                      "else\n"
                      "  >&2 echo \"No app env file found: '" env-sh "'\"\n"
                      "  >&2 echo \"Have you not started this service (" b.origin "/" b.name ") before?\"\n"
                      "  >&2 echo \"\"\n"
                      "  >&2 echo \"Aborting...\"\n"
                      "  exit 1\n"
                      "fi\n\n"
                      "cd " (b:join b.prefix app-prefix) "\n\n"
                      "exec " cmd " $@\n"))
    (b:chmod path "755")))

{:metadata
 (fn [plan settings dirs]
   (let [settings (or settings {})
         d (detect dirs.src.read dirs.src.json settings)
         _ (set detected d)
         package d.package
         svc-run (and plan.svc plan.svc.run)]
     (when (and (= nil (. d.bins "web")) (not svc-run))
       (error "A default proccess bin called 'web' could not be detected from a Procfile or package.json."))
     (let [added {:deps [d.node "karate/busybox-static"]
                  :build_deps (if (= d.pkg-manager "yarn") ["karate/yarn" "karate/git"] ["karate/git"])
                  :bin_dirs ["bin" (.. app-prefix "/node_modules/.bin")]
                  :exports {:port "app.port"}}
           author (if (= (type package.author) "table") package.author.name package.author)]
       (when (not svc-run) (set added.svc {:run (.. plan.name "-web")}))
       (when (and package.description (not= package.description "")) (set added.description package.description))
       (when (and package.license (not= package.license "")) (set added.license [package.license]))
       (when (and author (not= author "")) (set added.maintainer author))
       (when (and package.homepage (not= package.homepage "")) (set added.upstream_url package.homepage))
       added)))

 :prepare
 (fn [b]
   ;; The development dependencies, which build scripts need.
   (b:env "NODE_ENV" "development")
   (b:log "Setting NODE_ENV=development"))

 :build
 (fn [b]
   (let [d (found b)
         cache (work b)
         uses-git (= 0 (b:run ["git" "rev-parse" "--is-inside-work-tree"] {:check false}))]
     (b:mkdir cache)
     (when (and uses-git (b:exists (b:join b.src "node_modules"))
                (not= 0 (b:run ["git" "check-ignore" "node_modules"] {:check false})))
       (b:log "WARN: Detected directory 'node_modules' is not in .gitignore and is not empty. The contents of 'node_modules' will not be used when building this app.")
       (b:log "WARN: It is not recommended to commit your node modules into your codebase."))
     ;; The source project linked coreutils' env to /usr/bin/env here; a Dojo
     ;; build writes nothing outside itself, and the tools' #! lines are pointed
     ;; at Node below.
     (b:log (.. "Installing dependencies using " d.pkg-manager " " (b:capture [d.pkg-manager "--version"])))
     (if (= d.pkg-manager "npm")
         (do
           (each [_ name (ipairs ["package.json" ".npmrc" "npm-shrinkwrap.json" "gulpfile.ts" "tsconfig.json" "tsoa.json"])]
             (when (and (b:exists (b:join b.src name))
                        (or (not= name "package.json") (not (b:exists (b:join cache name)))))
               (b:copy (b:join b.src name) (b:join cache name))))
           (when (b:exists (b:join b.src "tools"))
             (b:copy (b:join b.src "tools") (b:join cache "tools")))
           (b:run ["npm" "install" "--unsafe-perm" "--loglevel" "error" "--fetch-retries" "5"
                   "--userconfig" (b:join cache ".npmrc")]
                  {:cwd cache :env (if (b:getenv "DOJ_NONINTERACTIVE") {"NPM_CONFIG_PROGRESS" "false"} {})})
           (b:write (b:join cache "npm-list.json") (b:capture ["npm" "list" "--json"] {:cwd cache})))
         (do
           (let [argv ["yarn" "install"]]
             (when (b:getenv "DOJ_NONINTERACTIVE") (table.insert argv "--no-progress"))
             (each [_ a (ipairs ["--pure-lockfile" "--ignore-engines" "--cache-folder" (b:join cache "yarn_cache")])]
               (table.insert argv a))
             (b:run argv))
           (b:remove (b:join cache "node_modules"))
           (b:copy (b:join b.src "node_modules") (b:join cache "node_modules"))))
     (b:log "Dependency installation completed")
     ;; Each tool's #! lines name this build's Node.
     (let [shebang (.. "#!" (b:path_for d.node) "/bin/node")
           bins (b:join cache "node_modules/.bin")]
       (b:log "Fixing Node shebang for node_module bins")
       (when (b:exists bins)
         (each [_ bin (ipairs (b:glob bins "*"))]
           (when (b:exists bin)
             ;; Every line that starts with #!, as `sed s|^#!.*$|...|` did.
             (let [real (b:capture ["readlink" "-f" bin])
                   text (b:read real)
                   out []]
               (each [line (: (.. text "\n") :gmatch "(.-)\n")]
                 (table.insert out (if (line:match "^#!") shebang line)))
               (b:write real (table.concat out "\n")))))))
     ;; Defaults for what the plan's default.toml does not set.
     (let [settings (settings-of b)
           own (let [file (b:join b.plan_dir "default.toml")] (if (b:exists file) (b:read file) ""))
           lines [""]]
       (when (not (toml-has own "node_env"))
         (table.insert lines "node_env = \"production\""))
       (when (not (toml-has own "app"))
         (table.insert lines "")
         (table.insert lines "[app]")
         (when (not (toml-has own "app.port"))
           (table.insert lines (.. "port = " (or settings.app_port 8000)))))
       (b:write (b:join cache "default.scaffolding.toml") (.. (table.concat lines "\n") "\n")))))

 :install
 (fn [b]
   (let [d (found b)
         cache (work b)
         app (b:join b.prefix app-prefix)
         uses-git (= 0 (b:run ["git" "rev-parse" "--is-inside-work-tree"] {:check false}))
         listing (if uses-git
                     (.. (b:capture ["git" "ls-files"]) "\n" (b:capture ["git" "ls-files" "--exclude-standard" "--others"]) "\n")
                     (.. (b:capture ["find" "."]) "\n"))
         archive (b:join cache "app.tar")
         tar (.. (b:path_for "karate/tar") "/bin/tar")]
     (b:log (.. "Installing app codebase to " app))
     (b:mkdir app)
     ;; The app's files, as the source project's tar pipe copied them.
     (b:run [tar "-cp" "--owner=root:0" "--group=root:0" "--no-xattrs" "--exclude-backups" "--exclude-vcs"
             "--exclude=dojo" "--exclude=results" "--exclude=node_modules" "--files-from=-" "-f" archive]
            {:stdin listing})
     (b:run [tar "-x" "-C" app "-f" archive])
     (b:remove archive)
     (b:log (.. "Installing vendored Node modules to " app "/node_modules"))
     (b:remove (b:join app "node_modules"))
     (b:copy (b:join cache "node_modules") (b:join app "node_modules"))
     (when (and (b:exists (b:join cache "npm-list.json")) (not (b:exists (b:join app "npm-list.json"))))
       (b:copy (b:join cache "npm-list.json") (b:join app "npm-list.json")))
     (each [bin cmd (pairs d.bins)]
       (process-bin b bin cmd))
     ;; What the source project's build_config added: an init hook when the
     ;; plan has none, the scaffolding's defaults, and the app's environment.
     (when (not (b:exists (b:join b.plan_dir "hooks/init")))
       (b:log "No user-defined init hook found, generating init hook")
       (let [svc (.. "/doj/svc/" b.name)]
         (b:write (b:join b.prefix "hooks/init")
                  (.. "#!/bin/sh\nset -e\n\nexport HOME=\"" svc "/data\"\n. '" svc "/config/app_env.sh'\n\n"))
         (b:chmod (b:join b.prefix "hooks/init") "755")))
     (b:write (b:join b.prefix "default.toml") (b:read (b:join cache "default.scaffolding.toml")))
     (let [lines []]
       (each [name value (pairs (app-env (settings-of b)))]
         (table.insert lines (.. "export " name "='" value "'\n")))
       (table.sort lines)
       (b:write (b:join b.prefix "config/app_env.sh") (table.concat lines)))))

 ;; Strip has nothing to do for a Node app, and takes long over node_modules.
 :strip (fn [b] nil)}
