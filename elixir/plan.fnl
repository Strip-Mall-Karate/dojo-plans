;; elixir, ported from its plan.sh.
{:name "elixir"
 :origin "karate"
 :version "1.8.0"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["Apache-2.0"]
 :description "A dynamic, functional language designed for building scalable and maintainable applications. Elixir leverages the Erlang VM, known for running low-latency, distributed and fault-tolerant systems, while also being successfully used in web development and the embedded software domain."
 :upstream_url "http://elixir-lang.org"
 :source {:url "https://github.com/elixir-lang/elixir/archive/v1.8.0.tar.gz" :sha256 "fe896d8b2914f982d2e6fceeb585f59a8f92ad872653fc46c13df9ff86d69234"}
 :deps ["karate/busybox" "karate/cacerts" "karate/coreutils" "karate/openssl" "karate/erlang"]
 :build_deps ["karate/busybox" "karate/make"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :prepare (fn [b]
          (b:run ["localedef" "-i" "en_US" "-f" "UTF-8" "en_US.UTF-8"])
          (b:env "LC_ALL" "en_US.UTF-8")
          (b:env "LANG" "en_US.UTF-8"))
 :build (fn [b]
          (b:fix_interpreter [(b:join b.src "rebar")] "karate/coreutils" "bin/env")
          (b:fix_interpreter [(b:join b.src "rebar3")] "karate/coreutils" "bin/env")
          (b:fix_interpreter (b:glob (b:join b.src "bin") "*") "karate/coreutils" "bin/env")
          (b:fix_interpreter [(b:join b.src "lib/elixir/generate_app.escript")] "karate/coreutils" "bin/env")
          (b:run ["make"]))}
