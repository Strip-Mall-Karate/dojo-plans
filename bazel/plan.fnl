;; bazel, ported from its plan.sh.
(fn use-dependency-path [b path replacement]
  ;; The source project's studio linked a dependency's tool to `path` for the
  ;; build. A Dojo build writes nothing outside itself, so the build's scripts
  ;; name the dependency's tool instead.
  (each [_ f (ipairs (b:find b.src "*"))]
    (let [name (: f :match "[^/]+$")]
      (when (and (or (: name :match :^configure) (: name :match :^Makefile)
                     (: name :match :^ltmain) (: name :match "%.in$")
                     (: name :match "%.am$") (: name :match "%.ac$")
                     (: name :match "%.m4$") (: name :match "%.mk$")
                     (: name :match "%.sh$") (: name :match "%.pl$")
                     (: name :match "%.py$"))
                 (not (b:exists (b:join f "."))))
        (let [text (b:read f)
              escaped (pick-values 1
                                   (: path :gsub "[%^%$%(%)%%%.%[%]%*%+%-%?]"
                                      "%%%0"))
              (fixed n) (: text :gsub escaped
                           (pick-values 1 (: replacement :gsub "%%" "%%%%")))]
          (when (> n 0) (b:write f fixed)))))))

{:name :bazel
 :origin :karate
 :version :0.13.0
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:Apache-2.0]
 :description "Build and test software of any size, quickly and reliably"
 :upstream_url "https://www.bazel.build/"
 :source {:url "https://github.com/bazelbuild/bazel/releases/download/0.13.0/bazel-0.13.0-dist.zip"
          :sha256 :82e9035084660b9c683187618a29aa896f8b05b5f16ae4be42a80b5e5b6a7690}
 :deps [:karate/glibc
        :karate/corretto8
        :karate/gcc-libs
        :karate/zip
        :karate/unzip
        :karate/coreutils]
 :build_deps [:karate/python
              :karate/protobuf-cpp
              :karate/gcc
              :karate/libarchive
              :karate/which
              :karate/patch]
 :bin_dirs [:bin]
 :prepare (fn [b]
            (b:run [:patch :-p1 :-i (.. b.plan_dir :/do_not_clear_env.patch)]
                   {:cwd ".."})
            (use-dependency-path b :/usr/bin/env
                                 (b:path_for :karate/coreutils :bin/env)))
 :build (fn [b]
          (b:env :TMPDIR :/tmp)
          (b:run [:./compile.sh] {:cwd ".."}))
 :install (fn [b]
            (b:mkdir (.. b.prefix :/bin))
            (b:copy (b:join (b:join b.src "..") :output/bazel)
                    (b:join (.. b.prefix :/bin/)
                            (: (b:join (b:join b.src "..") :output/bazel)
                               :match "[^/]+$"))))
 :strip (fn [b]
          ;; From do_end.
          )}
