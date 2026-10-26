;; fluentd, ported from its plan.sh.
{:name "fluentd"
 :origin "karate"
 :version "1.0.2"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["Apache-2.0"]
 :description "Fluentd is an open source data collector, which lets you unify the data collection and consumption for a better use and understanding of data."
 :upstream_url "https://www.fluentd.org/"
 :deps ["karate/ruby" "karate/coreutils" "karate/bundler"]
 :build_deps ["karate/make" "karate/gcc" "karate/gcc-libs"]
 :bin_dirs ["bin"]
 :exports {"forward-port" "input.forward.port" "http-port" "input.http.port"}
 :exposes ["forward-port" "http-port"]
 :download (fn [b]
          nil)
 :verify (fn [b]
          nil)
 :unpack (fn [b]
          nil)
 :build (fn [b]
          (var v--bundler-dir "")
          (set v--bundler-dir (b:path_for "bundler"))
          ;; The plan named $pkg_path, which nothing sets, so GEM_HOME was /vendor/bundle;
          ;; bundle installs into ./vendor/bundle, so that is GEM_HOME here.
          (b:env "GEM_HOME" (b:join b.src "vendor/bundle"))
          (b:env "GEM_PATH" (.. v--bundler-dir ":" (or (b:getenv "GEM_HOME") "")))
          (b:write (b:join b.src "Gemfile") (.. "    source 'https://rubygems.org'\n    gem 'fluentd', '= " b.version "'\n"))
          (b:run ["bundle" "install" "--jobs" "2" "--retry" "5" "--path" "./vendor/bundle" "--binstubs"]))
 :install (fn [b]
          (b:copy b.src (b:join (.. b.prefix "/") (: b.src :match "[^/]+$")))
          (b:fix_interpreter (b:glob (.. b.prefix "/bin") "*") "karate/coreutils" "bin/env"))}
