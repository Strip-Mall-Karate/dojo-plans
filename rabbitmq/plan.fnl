;; rabbitmq, ported from its plan.sh.
{:name "rabbitmq"
 :origin "karate"
 :version "3.7.8"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["MPL"]
 :description "Open source multi-protocol messaging broker"
 :upstream_url "https://www.rabbitmq.com"
 :source {:url "https://github.com/rabbitmq/rabbitmq-server/releases/download/v3.7.8/rabbitmq-server-3.7.8.tar.xz" :sha256 "bed39fd72b8c932fe5f356fbbc7d30a19d651213e1667d81f084bc31468f5a02" :dirname "rabbitmq-server-3.7.8"}
 :deps ["karate/coreutils" "karate/glibc" "karate/erlang"]
 :build_deps ["karate/bash" "karate/diffutils" "karate/gawk" "karate/gcc" "karate/git" "karate/grep" "karate/libxml2" "karate/libxslt" "karate/make" "karate/perl" "karate/python2" "karate/rsync" "karate/unzip" "karate/zip" "karate/elixir"]
 :bin_dirs ["sbin"]
 :include_dirs ["include"]
 :exports {"port" "listeners.tcp.default"}
 :exposes ["port"]
 :prepare (fn [b]
          (b:env "PREFIX" b.prefix)
          (b:log (.. "Setting PREFIX=" (or (b:getenv "PREFIX") "")))
          (b:env "DESTDIR" (or (b:getenv "PREFIX") ""))
          (b:log (.. "Setting DESTDIR=" (or (b:getenv "DESTDIR") "")))
          (b:env "RMQ_ROOTDIR" "")
          (b:log (.. "Setting RMQ_ROOTDIR=" (or (b:getenv "RMQ_ROOTDIR") "")))
          (b:env "RMQ_LIBDIR" "")
          (b:log (.. "Setting RMQ_LIBDIR=" (or (b:getenv "RMQ_LIBDIR") "")))
          (b:env "RMQ_ERLAPP_DIR" "")
          (b:log (.. "Setting RMQ_ERLAPP_DIR=" (or (b:getenv "RMQ_ERLAPP_DIR") "")))
          (b:env "LANG" "en_US.utf8")
          (b:env "LANGUAGE" "en_US:")
          (b:env "LC_ALL" "en_US.UTF-8")
          (b:log "Setting locale to en_US.utf8"))
 :build (fn [b]
          (b:run ["make"]))
 :check (fn [b]
          (b:run ["make" "tests"]))}
