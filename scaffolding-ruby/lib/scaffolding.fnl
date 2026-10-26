;; Scaffolding for Ruby applications: Rails 4.2 and 5, and Rack apps.
;;
;; A plan using it has no source: its directory, with a Gemfile and a
;; Gemfile.lock, is the application. The scaffolding reads Gemfile.lock for the
;; app type, the gems that need packages (sqlite3, pg, nokogiri, execjs,
;; webpacker) and the Ruby version; installs the gems with Bundler; and
;; packages the app under app/ with its gems, binstubs and a bin per process.
;; Settings, in the plan's `:scaffolding {:settings ...}`:
;;
;;   :ruby_pkg         the Ruby package, instead of the one Gemfile.lock names
;;   :app_port         the app's port in default.toml (8000)
;;   :env              more variables for the app's environment, name to value
;;   :process_bins     more processes, name to command; they win over detected ones
;;   :symlinked_dirs   more app directories to keep under the service's var path

(local app-prefix "app")

(local pg-gems ["pg" "activerecord-jdbcpostgresql-adapter" "jdbc-postgres" "jdbc-postgresql"
                "jruby-pg" "rjack-jdbc-postgres" "tgbyte-activerecord-jdbcpostgresql-adapter"])

(fn trim [s]
  (or (s:match "^%s*(.-)%s*$") ""))

;; Gem::Version's order: segments split at dots and between digits and
;; letters; a letter segment (a prerelease) sorts before any number, and
;; missing segments count as 0.
(fn version-segments [v]
  (let [out []]
    (each [part (v:gmatch "[^.]+")]
      (var rest part)
      (while (> (length rest) 0)
        (let [num (rest:match "^%d+")
              word (rest:match "^%a+")]
          (if num
              (do (table.insert out (tonumber num)) (set rest (rest:sub (+ (length num) 1))))
              word
              (do (table.insert out word) (set rest (rest:sub (+ (length word) 1))))
              (set rest (rest:sub 2))))))
    out))

(fn version-compare [a b]
  (let [x (version-segments a)
        y (version-segments b)]
    (var result 0)
    (for [i 1 (math.max (length x) (length y))]
      (when (= result 0)
        (let [p (or (. x i) 0)
              q (or (. y i) 0)]
          (set result
               (if (= (type p) (type q))
                   (if (< p q) -1 (> p q) 1 0)
                   (= (type p) "string") -1
                   1)))))
    result))

(fn parse-lockfile [text]
  ;; The specs of Gemfile.lock's GEM, GIT and PATH sections (name to version)
  ;; and its RUBY VERSION, as Bundler's LockfileParser reads them.
  (let [specs {}]
    (var section nil)
    (var ruby nil)
    (each [line (text:gmatch "[^\n]+")]
      (if (line:match "^%S")
          (set section (trim line))
          (and (or (= section "GEM") (= section "GIT") (= section "PATH")) (line:match "^    %S"))
          (let [(name version) (line:match "^    (%S+) %(([^)]+)%)")]
            (when name
              ;; A platform-specific gem: `nokogiri (1.8.2-x86_64-linux)`.
              (tset specs name (or (version:match "^([^-]+)%-") version))))
          (and (= section "RUBY VERSION") (line:match "^%s+ruby "))
          ;; Bundler drops the first patch level (`p105`), wherever it is.
          (set ruby (pick-values 1 (: (trim line) :gsub "p%d+" "" 1)))))
    {:specs specs :ruby ruby}))

(fn has-gem [d name]
  (not= nil (. d.specs name)))

(fn gem-in [d name low high]
  ;; Whether the gem is present with low <= version < high (either may be nil).
  (let [v (. d.specs name)]
    (and v
         (or (not low) (>= (version-compare v low) 0))
         (or (not high) (< (version-compare v high) 0)))))

(fn set-if-unset [t k v]
  (when (= nil (. t k)) (tset t k v)))

(fn detect [read settings]
  (when (not (read "Gemfile"))
    (error "Ruby Scaffolding cannot find Gemfile in the root directory"))
  (let [lock (read "Gemfile.lock")
        _ (when (not lock)
            (error "Ruby Scaffolding cannot find Gemfile.lock: run `bundle lock` and add it to the app"))
        d (parse-lockfile lock)
        has-rakefile (accumulate [found false _ name (ipairs ["Rakefile" "rakefile" "rakefile.rb" "Rakefile.rb"])]
                       (or found (not= nil (read name))))
        unsupported (fn [kind] (error (.. kind " app types not yet supported with this Scaffolding")))]
    ;; The app type, as the source project's detectors ran, first match wins.
    (set d.app-type
         (if (gem-in d "railties" "5.0.0" "6.0.0") "rails5"
             (gem-in d "railties" "4.2.0" "5.0.0") "rails42"
             (gem-in d "railties" "4.1.0.beta1" "5.0.0") (unsupported "Rails 4.1")
             (gem-in d "railties" "4.0.0.beta" "4.1.0.beta1") (unsupported "Rails 4")
             (gem-in d "railties" "3.0.0" "4.0.0") (unsupported "Rails 3")
             (gem-in d "railties" "2.0.0" "3.0.0") (unsupported "Rails 2")
             (has-gem d "rack") "rack"
             (unsupported "Ruby")))
    (let [rails (= "rails" (d.app-type:sub 1 5))]
      (when (and (= d.app-type "rails5") (not (has-gem d "tzinfo-data")))
        (error (.. "A required gem 'tzinfo-data' is missing from the Gemfile. If a 'gem \"tzinfo-data\", platforms: [...]' line exists,"
                   " simply remove the comma and 'platforms:' section, run 'bundle update' to update the Gemfile.lock, and retry the build.")))
      (when (and (gem-in d "railties" "3.0.0" "5.0.0") (not (has-gem d "rails_12factor")))
        (error (.. "A required gem 'rails_12factor' is missing from the Gemfile. Add the gem to your Gemfile,"
                   " run 'bundle install' to update the Gemfile.lock, and retry the build.")))
      ;; Processes: the plan's, the Procfile's, then the app type's.
      (let [bins {}]
        (each [name cmd (pairs (or settings.process_bins {}))] (tset bins name cmd))
        (let [procfile (read "Procfile")]
          (when procfile
            (each [line (procfile:gmatch "[^\n]+")]
              (when (not (line:match "^#"))
                (let [(name cmd) (line:match "^([^:]*):(.*)$")]
                  (when name (set-if-unset bins (trim name) (trim cmd))))))))
        (if rails
            (do (set-if-unset bins "web" "bundle exec rails server -p $PORT")
                (set-if-unset bins "console" "bundle exec rails console"))
            (= d.app-type "rack")
            (do (set-if-unset bins "web" "bundle exec rackup config.ru -p $PORT")
                (set-if-unset bins "console" "bundle exec irb")))
        (when (and (has-gem d "rake") has-rakefile)
          (set-if-unset bins "rake" "bundle exec rake"))
        (set-if-unset bins "sh" "sh")
        (set d.bins bins))
      ;; The app's environment and the directories kept under the service.
      (let [env {}
            dirs (icollect [_ dir (ipairs (or settings.symlinked_dirs []))] dir)]
        (each [name value (pairs (or settings.env {}))] (tset env name value))
        (set-if-unset env "LANG" "{{cfg.lang}}")
        (set-if-unset env "PORT" "{{cfg.app.port}}")
        (if rails
            (do
              (each [_ dir (ipairs ["log" "tmp" "public/system"])] (table.insert dirs dir))
              (set-if-unset env "RAILS_ENV" "{{cfg.rails_env}}")
              (set-if-unset env "RACK_ENV" "{{cfg.rack_env}}")
              (when (gem-in d "railties" "5.0.0" nil) (set-if-unset env "RAILS_LOG_TO_STDOUT" "enabled"))
              (when (gem-in d "railties" "4.2.0" nil) (set-if-unset env "RAILS_SERVE_STATIC_FILES" "enabled"))
              (when (gem-in d "railties" "4.1.0" nil) (set-if-unset env "SECRET_KEY_BASE" "{{cfg.secret_key_base}}")))
            (= d.app-type "rack")
            (set-if-unset env "RACK_ENV" "{{cfg.rack_env}}"))
        (set d.uses-pg (accumulate [found false _ gem (ipairs pg-gems)] (or found (has-gem d gem))))
        (when d.uses-pg
          (set-if-unset env "DATABASE_URL"
                        (.. "{{#if cfg.db.adapter}}{{cfg.db.adapter}}{{else}}postgresql{{/if}}://{{cfg.db.user}}:{{cfg.db.password}}"
                            "@{{#if bind.database}}{{bind.database.first.sys.ip}}{{else}}{{#if cfg.db.host}}{{cfg.db.host}}{{else}}db.host.not.set{{/if}}{{/if}}"
                            ":{{#if bind.database}}{{bind.database.first.cfg.port}}{{else}}{{#if cfg.db.port}}{{cfg.db.port}}{{else}}5432{{/if}}{{/if}}"
                            "/{{cfg.db.name}}")))
        (set d.env env)
        (set d.symlinked-dirs dirs))
      (set d.has-rakefile has-rakefile)
      (set d.ruby-pkg (or settings.ruby_pkg
                          (and d.ruby (.. "karate/ruby/" (or (d.ruby:match "^%S+ (%S+)") d.ruby)))
                          "karate/ruby"))
      d)))

;; What `metadata` detected when the plan loaded; the module stays loaded for
;; the build's phases.
(var detected nil)

(fn found []
  (or detected (error "scaffolding-ruby: the plan's metadata was not read")))

(fn settings-of [b]
  (or b.scaffolding_settings {}))

(fn work [b]
  (b:join b.cache (.. b.name "-" b.version)))

(fn toml-has [text key]
  ;; Whether default.toml sets `key` (a top-level key, a table, or table.key).
  (let [(tbl field) (key:match "^([^.]+)%.(.+)$")]
    (var section nil)
    (var hit false)
    (each [line (text:gmatch "[^\n]+")]
      (let [header (line:match "^%s*%[%s*([^%]]-)%s*%]")]
        (if header
            (do (set section header)
                (when (and (not tbl) (= header key)) (set hit true)))
            (let [name (line:match "^%s*([%w_%-]+)%s*=")]
              (when name
                (if tbl
                    (when (and (= section tbl) (= name field)) (set hit true))
                    (when (and (= section nil) (= name key)) (set hit true))))))))
    hit))

(fn ruby-bin [b d]
  (.. (b:path_for d.ruby-pkg) "/bin/ruby"))

(fn bundle [b d args opts]
  ;; `bundle` with the chosen Ruby and the bundler package's own gems.
  (let [bundler (b:path_for "karate/bundler")
        argv [(ruby-bin b d) (.. bundler "/bin/bundle.real")]
        opts (or opts {})
        env (or opts.env {})]
    (each [_ a (ipairs args)] (table.insert argv a))
    (tset env "GEM_HOME" bundler)
    (tset env "GEM_PATH" bundler)
    (tset env "RUBYOPT" "")
    (tset env "GEMRC" "")
    (set opts.env env)
    argv))

(fn run-bundle [b d args opts]
  (b:run (bundle b d args opts) (or opts {})))

(fn bundle-install [b d path extra opts]
  (let [args ["install"]]
    (each [_ a (ipairs extra)] (table.insert args a))
    (each [_ a (ipairs ["--jobs" (tostring b.jobs) "--without" "development:test" "--path" path
                        (.. "--shebang=" (ruby-bin b d)) "--no-clean" "--deployment"])]
      (table.insert args a))
    (run-bundle b d args opts)))

(fn rake-env [d]
  (if (= "rails" (d.app-type:sub 1 5)) {"RACK_ENV" "production" "RAILS_ENV" "production" "RAILS_GROUP" "assets"}
      (= d.app-type "rack") {"RACK_ENV" "production"}
      {}))

(fn fix-shebangs [b file shebang pattern]
  ;; Every line of `file` matching `pattern` becomes `shebang`.
  (let [text (b:read file)
        out []]
    (each [line (: (.. text "\n") :gmatch "(.-)\n")]
      (table.insert out (if (line:match pattern) shebang line)))
    (b:write file (table.concat out "\n"))))

(fn process-bin [b path cmd]
  (let [svc (.. "/doj/svc/" b.name)
        env-sh (.. svc "/config/app_env.sh")]
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

(fn wrap-ruby-bin [b d bin]
  (b:log (.. "Adding wrapper " bin " to " bin ".real"))
  (b:move bin (.. bin ".real"))
  (b:write bin (.. "#!" (b:path_for "karate/busybox-static") "/bin/sh\n"
                   "set -e\n"
                   "if test -n \"$DEBUG\"; then set -x; fi\n\n"
                   "export GEM_HOME=\"" (or (b:getenv "GEM_HOME") "") "\"\n"
                   "export GEM_PATH=\"" (or (b:getenv "GEM_PATH") "") "\"\n"
                   "unset RUBYOPT GEMRC\n\n"
                   "exec " (ruby-bin b d) " " bin ".real $@\n"))
  (b:chmod bin "755"))

(fn init-hook [b d]
  (let [svc (.. "/doj/svc/" b.name)
        lines ["#!/bin/sh" "set -e" "" (.. "export HOME=\"" svc "/data\"") (.. ". '" svc "/config/app_env.sh'") ""
               "# Create a directory for each app symlinked dir under $pkg_svc_var_path"]]
    (each [_ dir (ipairs d.symlinked-dirs)]
      (table.insert lines (.. "mkdir -pv '" svc "/var/" dir "'")))
    (table.insert lines "")
    (when (or (= d.app-type "rails5") (= d.app-type "rails42"))
      (each [_ l (ipairs [""
                          "# Check that the 'SECRET_KEY_BASE' environment variable is non-empty"
                          "if [ -z \"${SECRET_KEY_BASE:-}\" ]; then"
                          "  >&2 echo \"Required environment variable SECRET_KEY_BASE is not set.\""
                          "  >&2 echo \"Set this package's config setting 'secret_key_base' to a\""
                          "  >&2 echo \"non-empty value. You can run 'rails secret' in development\""
                          "  >&2 echo \"to generate a random key string.\""
                          "  >&2 echo \"\""
                          "  >&2 echo \"Aborting...\""
                          "  exit 5"
                          "fi"])]
        (table.insert lines l)))
    (when d.uses-pg
      (each [_ l (ipairs [""
                          "# Confirm an initial database connection"
                          (.. "if ! " (b:join b.prefix "libexec/is_db_connected") "; then")
                          "  >&2 echo \"\""
                          "  >&2 echo \"A database connection is required for this app to properly boot.\""
                          "  >&2 echo \"Is the database not running or are the database connection\""
                          "  >&2 echo \"credentials incorrect?\""
                          "  >&2 echo \"\""
                          "{{~#if bind.database}}"
                          "  >&2 echo \"This app started with a database bind and will discovery the\""
                          "  >&2 echo \"hostname and port number in the Dojo ring.\""
                          "  >&2 echo \"\""
                          "  >&2 echo \"There are 3 remaining config settings which must be set correctly:\""
                          "{{else}}"
                          "  >&2 echo \"This app started without a database bind meaning that the\""
                          "  >&2 echo \"database is assumed to be running outside of a Dojo ring.\""
                          "  >&2 echo \"Therefore, you must provide all the database connection values.\""
                          "  >&2 echo \"\""
                          "  >&2 echo \"There are 5 config settings which must be set correctly:\""
                          "{{~/if}}"
                          "  >&2 echo \"\""
                          "{{~#unless bind.database}}"
                          "  >&2 echo \" * db.host      - The database hostname or IP address (Current: {{#if cfg.db.host}}{{cfg.db.host}}{{else}}<unset>{{/if}})\""
                          "  >&2 echo \" * db.port      - The database listen port number (Current: {{#if cfg.db.port}}{{cfg.db.port}}{{else}}5432{{/if}})\""
                          "{{~/unless}}"
                          "  >&2 echo \" * db.adapter   - The database adapter (Current: {{#if cfg.db.adapter}}{{cfg.db.adapter}}{{else}}postgresql{{/if}})\""
                          "  >&2 echo \" * db.user      - The database username (Current: {{#if cfg.db.user}}{{cfg.db.user}}{{else}}<unset>{{/if}})\""
                          "  >&2 echo \" * db.password  - The database password (Current: {{#if cfg.db.password}}<set>{{else}}<unset>{{/if}})\""
                          "  >&2 echo \" * db.name      - The database name (Current: {{#if cfg.db.name}}{{cfg.db.name}}{{else}}<unset>{{/if}})\""
                          "  >&2 echo \"\""
                          "  >&2 echo \"Aborting...\""
                          "  exit 15"
                          "fi"])]
        (table.insert lines l)))
    (.. (table.concat lines "\n") "\n")))

{:metadata
 (fn [plan settings dirs]
   (let [settings (or settings {})
         d (detect dirs.src.read settings)
         deps [d.ruby-pkg]]
     (set detected d)
     ;; The packages the app's gems need, as the source project added them.
     (when (has-gem d "webpacker") (table.insert deps "karate/yarn"))
     (when (has-gem d "execjs") (table.insert deps "karate/node"))
     (when (has-gem d "nokogiri")
       (table.insert deps "karate/libxml2")
       (table.insert deps "karate/libxslt"))
     (when d.uses-pg (table.insert deps "karate/postgresql"))
     (when (has-gem d "sqlite3") (table.insert deps "karate/sqlite"))
     (table.insert deps "karate/busybox-static")
     (let [added {:deps deps
                  :build_deps ["karate/git"]
                  :bin_dirs ["bin" (.. app-prefix "/binstubs")]
                  :exports {:port "app.port"}}]
       (when (not (and plan.svc plan.svc.run))
         (set added.svc {:run (.. plan.name "-web")}))
       (when d.uses-pg
         ;; An optional binding called `database`, the PostgreSQL database.
         (set added.binds_optional {:database ["port"]}))
       added)))

 :prepare
 (fn [b]
   (let [d (found)
         ;; Ruby's engine, ABI version and gem path, from `ruby` itself.
         info (b:capture [(ruby-bin b d) "-rrbconfig" "-e"
                          "puts defined?(RUBY_ENGINE) ? RUBY_ENGINE : 'ruby'; puts RbConfig::CONFIG['ruby_version']; puts Gem.path.join(':')"])
         [engine version gem-path] (icollect [line (info:gmatch "[^\n]+")] line)
         ;; Home directory entries at the front of the gem path are left out.
         gem-path (pick-values 1 (: (or gem-path "") :gsub "^/root/%.gem/[^:]+:" ""))
         gem-dir (b:join b.prefix app-prefix "vendor/bundle" engine version)]
     (set d.cache-gem-dir (b:join (work b) "vendor/bundle" engine version))
     (b:env "BUNDLE_SILENCE_ROOT_WARNING" "1")
     (if (b:exists (b:join b.src ".bundle/config"))
         (do
           (b:log "Detecting existing bundler config. Temporarily renaming ...")
           (b:move (b:join b.src ".bundle/config") (b:join b.src ".bundle/config.prehab"))
           (set d.dot-bundle true))
         (b:exists (b:join b.src ".bundle/."))
         (set d.dot-bundle true))
     (b:env "GEM_HOME" gem-dir)
     (b:log (.. "Setting GEM_HOME=" gem-dir))
     (b:env "GEM_PATH" (.. gem-dir ":" gem-path))
     (b:log (.. "Setting GEM_PATH=" gem-dir ":" gem-path))))

 :build
 (fn [b]
   (let [d (found)
         cache (work b)
         settings (settings-of b)
         restore (fn []
                   (when (b:exists (b:join b.src ".bundle/config.prehab"))
                     (b:log "Restoring original bundler config")
                     (b:remove (b:join b.src ".bundle/config"))
                     (b:move (b:join b.src ".bundle/config.prehab") (b:join b.src ".bundle/config"))))]
     (b:mkdir cache)
     (b:log "Installing dependencies using Bundler")
     (when (not= 0 (bundle-install b d (b:join cache "vendor/bundle") ["--retry" "5"] {:check false}))
       (restore)
       (error "bundler returned an error"))
     (b:log "Bundle completed")
     (restore)
     (when (not d.dot-bundle)
       (b:remove (b:join b.src ".bundle")))
     (b:log "Removing installed gem cache")
     (b:remove (b:join d.cache-gem-dir "cache"))
     (b:log "Fixing Ruby shebang for RubyGems bins")
     (each [_ bin (ipairs (b:find (b:join d.cache-gem-dir "bin") "*"))]
       (when (not (b:exists (b:join bin ".")))
         (fix-shebangs b bin (.. "#!" (ruby-bin b d)) "^#!")))
     ;; Defaults for what the plan's default.toml does not set.
     (let [own (let [file (b:join b.plan_dir "default.toml")] (if (b:exists file) (b:read file) ""))
           lines [""]
           add (fn [...] (each [_ l (ipairs [...])] (table.insert lines l)))]
       (when (and (not (toml-has own "secret_key_base")) d.env.SECRET_KEY_BASE)
         (add "# Rails' secret key base is required and must be non-empty"
              "# You can run 'rails secret' in development to generate"
              "# a random key string."
              "secret_key_base = \"\""
              ""))
       (when (not (toml-has own "lang")) (add "lang = \"en_US.UTF-8\""))
       (when (and (not (toml-has own "rack_env")) d.env.RACK_ENV) (add "rack_env = \"production\""))
       (when (and (not (toml-has own "rails_env")) d.env.RAILS_ENV) (add "rails_env = \"production\""))
       (when (not (toml-has own "app"))
         (add "" "[app]")
         (when (not (toml-has own "app.port"))
           (add (.. "port = " (or settings.app_port 8000)))))
       (when (and d.uses-pg (not (toml-has own "db")))
         (add "" "[db]")
         (when (not (toml-has own "db.adapter")) (add "adapter = \"postgresql\""))
         (when (not (toml-has own "db.name")) (add (.. "name = \"" b.name "_production\"")))
         (when (not (toml-has own "db.user")) (add (.. "user = \"" b.name "\"")))
         (when (not (toml-has own "db.password")) (add (.. "password = \"" b.name "\""))))
       (b:write (b:join cache "default.scaffolding.toml") (.. (table.concat lines "\n") "\n")))))

 :install
 (fn [b]
   (let [d (found)
         cache (work b)
         app (b:join b.prefix app-prefix)
         tar (.. (b:path_for "karate/tar") "/bin/tar")
         uses-git (= 0 (b:run ["git" "rev-parse" "--is-inside-work-tree"] {:check false}))
         listing (if uses-git
                     (.. (b:capture ["git" "ls-files"]) "\n" (b:capture ["git" "ls-files" "--exclude-standard" "--others"]) "\n")
                     (.. (b:capture ["find" "."]) "\n"))
         archive (b:join cache "app.tar")
         shebang (.. "#!" (ruby-bin b d))]
     (b:log (.. "Installing app codebase to " app))
     (b:mkdir app)
     (b:run [tar "-cp" "--owner=root:0" "--group=root:0" "--no-xattrs" "--exclude-backups" "--exclude-vcs"
             "--exclude=dojo" "--exclude=vendor/bundle" "--exclude=results" "--files-from=-" "-f" archive]
            {:stdin listing})
     (b:run [tar "-x" "-C" app "-f" archive])
     (b:remove archive)
     (b:log (.. "Installing vendored gems to " app "/vendor/bundle"))
     (b:mkdir (b:join app "vendor"))
     (b:copy (b:join cache "vendor/bundle") (b:join app "vendor/bundle"))
     (b:log (.. "Generating app binstubs in " app "/binstubs"))
     (b:remove (b:join app ".bundle"))
     (bundle-install b d (b:join app "vendor/bundle") ["--local" "--quiet" (.. "--binstubs=" (b:join app "binstubs"))] {:cwd app})
     ;; Bundler itself, from the bundler package's cached gem.
     (let [bundler (b:path_for "karate/bundler")
           gem (. (b:glob (b:join bundler "cache") "bundler-*.gem") 1)]
       (b:log (.. "Vendoring " (gem:match "[^/]+$")))
       (b:run ["gem" "install" "--local" gem "--install-dir" (b:getenv "GEM_HOME")
               "--bindir" (b:join app "binstubs") "--no-ri" "--no-rdoc"])
       (wrap-ruby-bin b d (b:join app "binstubs/bundle"))
       (wrap-ruby-bin b d (b:join app "binstubs/bundler")))
     (b:log (.. "Installing support programs into " b.prefix "/libexec"))
     (b:mkdir (b:join b.prefix "libexec"))
     (each [_ src (ipairs (b:glob (b:join (b:path_for "karate/scaffolding-ruby") "libexec") "*"))]
       (let [dst (b:join b.prefix "libexec" (src:match "[^/]+$"))]
         (b:copy src dst)
         (fix-shebangs b dst shebang "^#!/usr/bin/env .*$")
         (process-bin b (dst:gsub "%.[^./]*$" "") (.. "bundle exec " dst))))
     (b:log "Fixing Ruby shebang for binstubs")
     (each [_ binstub (ipairs (b:find (b:join app "binstubs") "*"))]
       (when (not (b:exists (b:join binstub ".")))
         (fix-shebangs b binstub shebang "^#!/usr/bin/env /.*/bin/ruby$")))
     ;; Rake's assets:precompile, when the app has one.
     (when (and (has-gem d "rake") d.has-rakefile)
       (let [opts {:cwd app :env (rake-env d)}
             tasks (.. "\n" (b:capture (bundle b d ["exec" "rake" "-P" "--trace"] opts) opts) "\n")]
         (when (tasks:find "\nrake assets:precompile\n" 1 true)
           (b:log "Detected and running Rake 'assets:precompile'")
           (let [env (rake-env d)]
             (tset env "DATABASE_URL" (or (b:getenv "DATABASE_URL") "postgresql://nobody@nowhere/fake_db_to_appease_rails_env"))
             (run-bundle b d ["exec" "rake" "assets:precompile"] {:cwd app :env env})))))
     (each [_ entry (ipairs d.symlinked-dirs)]
       (let [dir (b:join app entry)
             target (.. "/doj/svc/" b.name "/var/" entry)]
         (b:log (.. "Creating directory symlink to '" target "' for '" dir "'"))
         (b:remove dir)
         (b:mkdir (dir:match "^(.*)/[^/]+$"))
         (b:symlink target dir)))
     (each [bin cmd (pairs d.bins)]
       (process-bin b (b:join b.prefix "bin" (.. b.name "-" bin)) cmd))
     ;; What the source project's build_config added: an init hook when the
     ;; plan has none, the scaffolding's defaults, and the app's environment.
     (when (not (b:exists (b:join b.plan_dir "hooks/init")))
       (b:log "No user-defined init hook found, generating init hook")
       (b:write (b:join b.prefix "hooks/init") (init-hook b d))
       (b:chmod (b:join b.prefix "hooks/init") "755"))
     (b:write (b:join b.prefix "default.toml") (b:read (b:join cache "default.scaffolding.toml")))
     (let [lines []]
       (each [name value (pairs d.env)]
         (table.insert lines (.. "export " name "='" value "'\n")))
       (table.sort lines)
       (b:write (b:join b.prefix "config/app_env.sh") (table.concat lines)))))}
