;; govc, ported from its plan.sh.
(var v-go-pkg "")
{:name "govc"
 :origin "karate"
 :version "0.19.0"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["Apache-2.0"]
 :description "govc is a vSphere CLI built on top of govmomi."
 :upstream_url "https://github.com/vmware/govmomi"
 :deps ["karate/glibc"]
 :build_deps ["karate/go" "karate/git" "karate/gcc"]
 :bin_dirs ["bin"]
 :download (fn [b]
          ;; From do_before.
          (b:env "GOPATH" (.. b.cache "/govc-" b.version))
          (set v-go-pkg "github.com/vmware/govmomi"))
 :verify (fn [b]
          nil)
 :unpack (fn [b]
          (b:run ["git" "clone" "--quiet" "--config" "advice.detachedHead=false" "--branch" (.. "v" b.version) "https://github.com/vmware/govmomi" (.. (or (b:getenv "GOPATH") "") "/src/" v-go-pkg)]))
 :build (fn [b]
          (b:run ["go" "build"] {:cwd (.. "src/" v-go-pkg "/govc")}))
 :install (fn [b]
          (b:copy (b:join b.src (.. "src/" v-go-pkg "/govc/govc")) (b:join (.. b.prefix "/bin/") (: (b:join b.src (.. "src/" v-go-pkg "/govc/govc")) :match "[^/]+$"))))}
