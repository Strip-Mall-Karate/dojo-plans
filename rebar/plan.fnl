;; rebar, ported from its plan.sh.
;; Deprecated: true
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
{:name "rebar"
 :origin "karate"
 :version "2.6.4"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["Apache-2.0"]
 :description "rebar is an Erlang build tool that makes it easy to compile and test Erlang applications, port drivers and releases."
 :upstream_url "https://github.com/rebar/rebar"
 :source {:url "https://github.com/rebar/rebar/archive/2.6.4.tar.gz" :sha256 "577246bafa2eb2b2c3f1d0c157408650446884555bf87901508ce71d5cc0bd07"}
 :deps ["karate/erlang" "karate/busybox-static"]
 :build_deps ["karate/coreutils"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :prepare (fn [b]
          (use-dependency-path b "/usr/bin/env" (b:path_for "coreutils" "bin/env")))
 :build (fn [b]
          (b:run ["./bootstrap"]))
 :install (fn [b]
          (if (b:exists (.. b.prefix "/bin/rebar"))
            (b:copy (b:join b.src "rebar") (b:join (.. b.prefix "/bin/rebar") (: (b:join b.src "rebar") :match "[^/]+$")))
            (b:copy (b:join b.src "rebar") (.. b.prefix "/bin/rebar")))
          (b:fix_interpreter (b:glob (.. b.prefix "/bin") "*") "karate/busybox-static" "bin/env"))
 :strip (fn [b]
          (b.default.strip b)
          ;; From do_end.
          )}
