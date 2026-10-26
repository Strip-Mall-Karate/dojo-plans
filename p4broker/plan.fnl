;; p4broker, ported from its plan.sh.
{:name "p4broker"
 :origin "karate"
 :version "18.1"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["Apache-2.0"]
 :description "Helix' P4Broker daemon service for proxying requests through to a Helix PerForce server."
 :upstream_url "https://www.perforce.com/downloads/helix-broker-p4broker"
 :source {:url "http://www.perforce.com/downloads/perforce/r18.1/bin.linux26x86_64/p4broker" :sha256 "5be8b8e6c327e590d83c0597d27120fee1ff628f568342309bcde4b5b6e669d9" :filename "p4broker"}
 :deps ["karate/glibc"]
 :build_deps ["karate/patchelf"]
 :bin_dirs ["bin"]
 :exports {"host" "srv.address" "port" "srv.port"}
 :exposes ["port"]
 :unpack (fn [b]
          nil)
 :build (fn [b]
          nil)
 :install (fn [b]
          (b:mkdir (.. b.prefix "/bin"))
          (if (b:exists (.. b.prefix "/bin/p4broker"))
            (b:copy (.. b.cache "/p4broker") (b:join (.. b.prefix "/bin/p4broker") (: (.. b.cache "/p4broker") :match "[^/]+$")))
            (b:copy (.. b.cache "/p4broker") (.. b.prefix "/bin/p4broker")))
          (b:chmod (.. b.prefix "/bin/p4broker") "+x")
          (b:run ["patchelf" "--interpreter" (.. (b:path_for "glibc") "/lib/ld-linux-x86-64.so.2") (.. b.prefix "/bin/p4broker")]))
 :strip (fn [b]
          nil)}
