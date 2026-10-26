;; musl, ported from its plan.sh.
{:name "musl"
 :origin "karate"
 :version "1.1.19"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["MIT"]
 :description "musl is a new standard library to power a new generation of Linux-based devices. musl is lightweight, fast, simple, free, and strives to be correct in the sense of standards-conformance and safety."
 :upstream_url "https://www.musl-libc.org/"
 :source {:url "http://www.musl-libc.org/releases/musl-1.1.19.tar.gz" :sha256 "db59a8578226b98373f5b27e61f0dd29ad2456f4aa9cec587ba8c24508e4c1d9"}
 :build_deps ["karate/coreutils" "karate/diffutils" "karate/gcc" "karate/make" "karate/patch" "karate/sed"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :prepare (fn [b]
          (var v-stack-size "")
          (set v-stack-size "2097152")
          (b:log (.. "Setting default stack size to '" v-stack-size "' from default '81920'"))
          (let [text (b:read (b:join b.src "src/internal/pthread_impl.h")) ends (= (text:sub -1) "\n") lines [] out []]
            (each [l (string.gmatch (if ends text (.. text "\n")) "(.-)\n")] (table.insert lines l))
            (each [n l (ipairs lines)]
              (var line l) (var deleted false) (local after [])
              (when (not deleted) (set line (pick-values 1 (string.gsub line "#define DEFAULT_STACK_SIZE .*" (.. "#define DEFAULT_STACK_SIZE " (pick-values 1 (: v-stack-size :gsub "%%" "%%%%"))) 1))))
              (when (not deleted) (table.insert out line))
              (each [_ x (ipairs after)] (table.insert out x)))
            (b:write (b:join b.src "src/internal/pthread_impl.h") (.. (table.concat out "\n") (if (and ends (> (length out) 0)) "\n" "")))))
 :build (fn [b]
          (b:run ["./configure" (.. "--prefix=" b.prefix) (.. "--syslibdir=" b.prefix "/lib")])
          (b:run ["make" "-j" (tostring b.jobs)]))
 :install (fn [b]
          (b.default.install b)
          (b:copy (b:join b.src "COPYRIGHT") (.. b.prefix "/share/licenses/COPYRIGHT"))
          (b:chmod (.. b.prefix "/share/licenses/COPYRIGHT") "0644"))}
