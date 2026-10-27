;; go17, ported from its plan.sh.
;; go17 1.7.6, the latest release on 2026-10-26: 1.7.5's source no longer downloads.
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
{:name "go17"
 :origin "karate"
 :version "1.7.6"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["BSD"]
 :description "Go is an open source programming language that makes it easy to\nbuild simple, reliable, and efficient software."
 :upstream_url "https://golang.org/"
 :source {:url "https://go.dev/dl/go1.7.6.src.tar.gz" :sha256 "1a67a4e688673fdff7ba41e73482b0e59ac5bd0f7acf703bc6d50cc775c5baba" :filename "go1.7.6.src.tar.gz" :dirname "go"}
 :deps ["karate/glibc" "karate/iana-etc" "karate/cacerts"]
 :build_deps ["karate/coreutils" "karate/inetutils" "karate/bash" "karate/patch" "karate/gcc" "karate/go14" "karate/perl"]
 :bin_dirs ["bin"]
 :prepare (fn [b]
          (var v-dynamic-linker "")
          (b:env "GOOS" "linux")
          (b:log (.. "Setting GOOS=" (or (b:getenv "GOOS") "")))
          (b:env "GOARCH" "amd64")
          (b:log (.. "Setting GOARCH=" (or (b:getenv "GOARCH") "")))
          (b:env "CGO_ENABLED" "1")
          (b:log (.. "Setting CGO_ENABLED=" (or (b:getenv "CGO_ENABLED") "")))
          (b:env "GOROOT" b.src)
          (b:log (.. "Setting GOROOT=" (or (b:getenv "GOROOT") "")))
          (b:env "GOBIN" (.. (or (b:getenv "GOROOT") "") "/bin"))
          (b:log (.. "Setting GOBIN=" (or (b:getenv "GOBIN") "")))
          (b:env "GOROOT_FINAL" b.prefix)
          (b:log (.. "Setting GOROOT_FINAL=" (or (b:getenv "GOROOT_FINAL") "")))
          (b:env "PATH" (.. (or (b:getenv "GOBIN") "") ":" (or (b:getenv "PATH") "")))
          (b:log (.. "Updating PATH=" (or (b:getenv "PATH") "")))
          (b:env "GOROOT_BOOTSTRAP" (b:path_for "go14"))
          (b:log (.. "Setting GOROOT_BOOTSTRAP=" (or (b:getenv "GOROOT_BOOTSTRAP") "")))
          (b:run ["patch" "-p1"] {:stdin (let [text (b:read (.. b.plan_dir "/cacerts.patch")) ends (= (text:sub -1) "\n") lines [] out []]
            (each [l (string.gmatch (if ends text (.. text "\n")) "(.-)\n")] (table.insert lines l))
            (each [n l (ipairs lines)]
              (var line l) (var deleted false) (local after [])
              (when (not deleted) (set line (pick-values 1 (string.gsub line "@cacerts@" (.. (pick-values 1 (: (b:path_for "cacerts") :gsub "%%" "%%%%")) "/ssl/cert.pem")))))
              (when (not deleted) (table.insert out line))
              (each [_ x (ipairs after)] (table.insert out x)))
            (.. (table.concat out "\n") (if (and ends (> (length out) 0)) "\n" "")))})
          (set v-dynamic-linker (.. (b:path_for "glibc") "/lib/ld-linux-x86-64.so.2"))
          (let [text (b:read (b:join b.src "src/cmd/link/internal/amd64/obj.go")) ends (= (text:sub -1) "\n") lines [] out []]
            (each [l (string.gmatch (if ends text (.. text "\n")) "(.-)\n")] (table.insert lines l))
            (each [n l (ipairs lines)]
              (var line l) (var deleted false) (local after [])
              (when (not deleted) (set line (pick-values 1 (string.gsub line "/lib64/ld%-linux%-x86%-64.so.2" (pick-values 1 (: v-dynamic-linker :gsub "%%" "%%%%")) 1))))
              (when (not deleted) (table.insert out line))
              (each [_ x (ipairs after)] (table.insert out x)))
            (b:write (b:join b.src "src/cmd/link/internal/amd64/obj.go") (.. (table.concat out "\n") (if (and ends (> (length out) 0)) "\n" ""))))
          (each [_ v-f (ipairs ["src/net/port_unix.go" "src/net/parse_test.go"])]
            (let [text (b:read (if (= (: v-f :sub 1 1) "/") v-f (b:join b.src v-f))) ends (= (text:sub -1) "\n") lines [] out []]
            (each [l (string.gmatch (if ends text (.. text "\n")) "(.-)\n")] (table.insert lines l))
            (each [n l (ipairs lines)]
              (var line l) (var deleted false) (local after [])
              (when (not deleted) (set line (pick-values 1 (string.gsub line "/etc/services" (.. (pick-values 1 (: (b:path_for "iana-etc") :gsub "%%" "%%%%")) "/etc/services") 1))))
              (when (not deleted) (table.insert out line))
              (each [_ x (ipairs after)] (table.insert out x)))
            (b:write (if (= (: v-f :sub 1 1) "/") v-f (b:join b.src v-f)) (.. (table.concat out "\n") (if (and ends (> (length out) 0)) "\n" ""))))))
 :build (fn [b]
          (b:run ["bash" "make.bash" "--no-clean"] {:cwd "src"}))
 :check (fn [b]
          (var v--clean-cmds [])
          (use-dependency-path b "/bin/pwd" (b:path_for "coreutils" "bin/pwd"))
          (use-dependency-path b "/usr/bin/env" (b:path_for "coreutils" "bin/env"))
          (use-dependency-path b "/bin/hostname" (b:path_for "inetutils" "bin/hostname"))
          (b:run ["env" (.. "LD_LIBRARY_PATH=" (b:path_for "gcc") "/lib") "bash" "run.bash" "--no-rebuild"] {:cwd "src"}))
 :install (fn [b]
          (b:copy (b:join b.src "bin") (b:join (.. b.prefix "/") (: (b:join b.src "bin") :match "[^/]+$")))
          (b:copy (b:join b.src "src") (b:join (.. b.prefix "/") (: (b:join b.src "src") :match "[^/]+$")))
          (b:copy (b:join b.src "lib") (b:join (.. b.prefix "/") (: (b:join b.src "lib") :match "[^/]+$")))
          (b:copy (b:join b.src "doc") (b:join (.. b.prefix "/") (: (b:join b.src "doc") :match "[^/]+$")))
          (b:copy (b:join b.src "misc") (b:join (.. b.prefix "/") (: (b:join b.src "misc") :match "[^/]+$")))
          (b:mkdir (.. b.prefix "/bin"))
          (b:mkdir (.. b.prefix "/pkg"))
          (b:copy (b:join b.src (.. "pkg/linux_" (or (b:getenv "GOARCH") ""))) (b:join (.. b.prefix "/pkg/") (: (b:join b.src (.. "pkg/linux_" (or (b:getenv "GOARCH") ""))) :match "[^/]+$")))
          (b:copy (b:join b.src "pkg/tool") (b:join (.. b.prefix "/pkg/") (: (b:join b.src "pkg/tool") :match "[^/]+$")))
          (when (b:exists (b:join b.src (.. "pkg/linux_" (or (b:getenv "GOARCH") "") "_race")))
            (b:copy (b:join b.src (.. "pkg/linux_" (or (b:getenv "GOARCH") "") "_race")) (b:join (.. b.prefix "/pkg/") (: (b:join b.src (.. "pkg/linux_" (or (b:getenv "GOARCH") "") "_race")) :match "[^/]+$"))))
          (b:copy (b:join b.src "favicon.ico") (.. b.prefix "/favicon.ico"))
          (b:chmod (.. b.prefix "/favicon.ico") "644")
          (b:copy (b:join b.src "LICENSE") (.. b.prefix "/share/licenses/LICENSE"))
          (b:chmod (.. b.prefix "/share/licenses/LICENSE") "644")
          (b:remove (.. b.prefix "/src/*.bat"))
          ;; Only bin and pkg hold commands: the scripts elsewhere (src, misc, lib) name
          ;; /usr/bin/perl, /bin/rc and /bin/bash, and are source.
          (b:run ["find" b.prefix "(" "-path" (.. b.prefix "/bin") "-o" "-path" (.. b.prefix "/pkg") ")" "-prune"
                  "-o" "-type" "f" "-perm" "/111" "-exec" "chmod" "a-x" "{}" "+"])
          ;; Test data includes programs linked for the build machine's /lib64.
          (b:run ["find" (.. b.prefix "/src") "-type" "d" "-name" "testdata" "-prune" "-exec" "rm" "-rf" "{}" "+"])
          (if (b:exists (.. b.prefix "/pkg/include"))
            (b:copy (.. b.prefix "/src/runtime") (b:join (.. b.prefix "/pkg/include") (: (.. b.prefix "/src/runtime") :match "[^/]+$")))
            (b:copy (.. b.prefix "/src/runtime") (.. b.prefix "/pkg/include"))))
 :strip (fn [b]
          (each [_ f (ipairs (b:glob (b:join b.prefix "bin") "*"))]
            (b:run ["strip" "-s" f]))
          (each [_ f (ipairs (b:glob (.. b.prefix "/pkg/tool/linux_" (or (b:getenv "GOARCH") "")) "*"))]
            (b:run ["strip" "-s" f])))}
