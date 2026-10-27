;; jffi, ported from its plan.sh.
{:name :jffi
 :origin :karate
 :version :1.2.18
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:Apache-2.0]
 :description "Java Foreign Function Interface"
 :upstream_url "https://github.com/jnr/jffi"
 :source {:url "https://github.com/jnr/jffi/archive/jffi-1.2.18.tar.gz"
          :sha256 :05326c985153e4c86449b9732cbaa39c7570f079cd0f1276c2f5df40ebacbd92
          :dirname :jffi-jffi-1.2.18}
 :deps [:karate/glibc :karate/libffi :karate/gcc-libs :karate/corretto8]
 :build_deps [:karate/corretto8
              :karate/ant
              :karate/pkg-config
              :karate/make
              :karate/gcc
              :karate/file
              :karate/diffutils
              :karate/maven]
 :prepare (fn [b]
            (b:log (.. "replacing /usr/bin/file with "
                       (b:path_for :karate/file) :/bin/file))
            (let [text (b:read (b:join b.src :jni/libffi/configure))
                  ends (= (text:sub -1) "\n")
                  lines []
                  out []]
              (each [l (string.gmatch (if ends text (.. text "\n")) "(.-)\n")]
                (table.insert lines l))
              (each [n l (ipairs lines)]
                (var line l)
                (var deleted false)
                (local after [])
                (when (not deleted)
                  (set line
                       (pick-values 1
                                    (string.gsub line :/usr/bin/file
                                                 (.. (pick-values 1
                                                                  (: (b:path_for :karate/file)
                                                                     :gsub "%%"
                                                                     "%%%%"))
                                                     :/bin/file)))))
                (when (not deleted) (table.insert out line))
                (each [_ x (ipairs after)] (table.insert out x)))
              (b:write (b:join b.src :jni/libffi/configure)
                       (.. (table.concat out "\n")
                           (if (and ends (> (length out) 0))
                               "\n"
                               ""))))
            (b:env :USE_SYSTEM_LIBFFI :1)
            (b:env :JAVA_HOME (b:path_for :corretto8)))
 :build (fn [b]
          (b:run [:ant :jar])
          (b:run [:ant
                  (.. :-Djava.library.path= (or (b:getenv :LD_RUN_PATH) ""))
                  :archive-platform-jar])
          (b:run [:mvn
                  (.. :-Djava.library.path= (or (b:getenv :LD_RUN_PATH) ""))
                  :package]))
 :install (fn [b]
            (if (b:exists b.prefix)
                (b:copy (b:join b.src :target)
                        (b:join b.prefix
                                (: (b:join b.src :target) :match "[^/]+$")))
                (b:copy (b:join b.src :target) b.prefix)))
 :strip (fn [b]
          nil)}
