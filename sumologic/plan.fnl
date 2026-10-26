;; sumologic, ported from its plan.sh.
{:name "sumologic"
 :origin "karate"
 :version "19.227-19"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["Apache-2.0"]
 :description "Sumo Logic’s powerful, scalable SaaS platform analyzes log data and metrics together in real time."
 :upstream_url "https://www.sumologic.com"
 :source {:url "https://collectors.sumologic.com/rest/download/tar" :sha256 "8a9329aaba7daa14bb0f9aadbfc0cffc1d149012b457c79fcb7b3537b1df95e0" :filename "SumoCollector_unix_19_227-19.tar.gz" :dirname "sumocollector"}
 :deps ["karate/gcc-libs" "karate/glibc" "karate/corretto8"]
 :build_deps ["karate/patchelf"]
 :bin_dirs ["sumologic/19.227-19/bin" "sumologic"]
 :lib_dirs ["sumologic/19.227-19/lib" "sumologic/19.227-19/bin/native/lib"]
 :svc {:user "root" :group "root"}
 :build (fn [b]
          nil)
 :install (fn [b]
          (b:run ["find" "." "-name" "*.bat" "-type" "f" "-delete"])
          (b:run ["find" "." "-name" "*.dll" "-type" "f" "-delete"])
          (b:run ["find" "." "-name" "*.cmd" "-type" "f" "-delete"])
          (if (b:exists (b:join b.src "wrapper"))
            (b:move (b:join b.src "tanuki/wrapper-linux-x86-64") (b:join (b:join b.src "wrapper") (: (b:join b.src "tanuki/wrapper-linux-x86-64") :match "[^/]+$")))
            (b:move (b:join b.src "tanuki/wrapper-linux-x86-64") (b:join b.src "wrapper")))
          (b:chmod (b:join b.src "wrapper") "+x")
          (b:chmod (.. b.version "/bin/collector") "+x")
          (b:move (b:join b.src "tanuki/linux64/libwrapper.so") (b:join (.. b.version "/bin/native/lib/") (: (b:join b.src "tanuki/linux64/libwrapper.so") :match "[^/]+$")))
          (b:remove (b:join b.src "powershell"))
          (b:remove (b:join b.src "tanuki"))
          (b:remove (b:join b.src "SumoEtw.man"))
          (b:remove (b:join b.src "collector"))
          (b:remove (b:join b.src "config"))
          (b:remove (.. b.version "/bin/native/lib/libsigar-universal64-macosx.dylib"))
          (b:remove (.. b.version "/bin/native/lib/libsigar-x86-linux.so"))
          (b:run ["patchelf" "--interpreter" (.. (b:path_for "glibc") "/lib/ld-linux-x86-64.so.2") "--set-rpath" (or (b:getenv "LD_RUN_PATH") "") "wrapper"])
          (if (b:exists (.. b.prefix "/" b.name))
            (b:copy b.src (b:join (.. b.prefix "/" b.name) (: b.src :match "[^/]+$")))
            (b:copy b.src (.. b.prefix "/" b.name))))
 :strip (fn [b]
          nil)}
