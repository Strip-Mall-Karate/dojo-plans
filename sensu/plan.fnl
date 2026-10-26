;; sensu, ported from its plan.sh.
{:name "sensu"
 :origin "karate"
 :version "1.6.2"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["MIT"]
 :description "A monitoring framework that aims to be simple, malleable, and scalable."
 :upstream_url "https://sensuapp.org"
 :deps ["karate/bundler" "karate/coreutils" "karate/gcc" "karate/ruby"]
 :build_deps ["karate/gcc-libs" "karate/libffi" "karate/make" "karate/openssl"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :svc {:user "root" :group "root"}
 :exports {"port" "api.port"}
 :exposes ["port"]
 :binds_optional {"rabbitmq" ["port"] "redis" ["port"]}
 :unpack (fn [b]
          (b:mkdir (.. b.cache "/" (.. b.name "-" b.version)))
          (if (b:exists (.. b.cache "/" (.. b.name "-" b.version) "/Gemfile"))
            (b:copy (b:join b.src "Gemfile") (b:join (.. b.cache "/" (.. b.name "-" b.version) "/Gemfile") (: (b:join b.src "Gemfile") :match "[^/]+$")))
            (b:copy (b:join b.src "Gemfile") (.. b.cache "/" (.. b.name "-" b.version) "/Gemfile"))))
 :prepare (fn [b]
          (var v--bundler-dir "")
          (set v--bundler-dir (b:path_for "bundler"))
          ;; The plan named $pkg_path, which nothing sets, so GEM_HOME was /vendor/bundle;
          ;; bundle installs into ./vendor/bundle, so that is GEM_HOME here.
          (b:env "GEM_HOME" (b:join b.src "vendor/bundle"))
          (b:env "GEM_PATH" (.. v--bundler-dir ":" (or (b:getenv "GEM_HOME") "")))
          (b:env "LD_RUN_PATH" (.. (b:path_for "gcc-libs") "/lib:" (b:path_for "libffi") "/lib:" (b:path_for "openssl") "/lib:" (or (b:getenv "LD_RUN_PATH") ""))))
 :build (fn [b]
          (b:run ["bundle" "install" "--jobs" "2" "--retry" "5" "--path" "./vendor/bundle" "--binstubs"] {:cwd (.. b.cache "/" (.. b.name "-" b.version))}))
 :install (fn [b]
          (b:copy (.. b.cache "/" (.. b.name "-" b.version)) (b:join (.. b.prefix "/") (: (.. b.cache "/" (.. b.name "-" b.version)) :match "[^/]+$")))
          (b:fix_interpreter (b:glob (.. b.prefix "/bin") "*") "karate/coreutils" "bin/env"))}
