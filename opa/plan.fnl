;; opa, ported from its plan.sh.
;; The source project's plan fetched opa with `go get` and reset it to the
;; v0.10.3 tag. This is that tag's archive, pinned; opa vendors its
;; dependencies and the tools `make deps` installs. Its Makefile stamps the
;; commit git reports, which an archive cannot; that is v0.10.3's.
{:name "opa"
 :origin "karate"
 :version "0.10.3"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["Apache-2.0"]
 :description "Open Policy Agent (OPA) is a lightweight general-purpose policy engine that can be co-located with your service."
 :upstream_url "https://www.openpolicyagent.org/"
 :source {:url "https://github.com/open-policy-agent/opa/archive/v0.10.3.tar.gz" :sha256 "5149cb58a73e47d2cc051f628e627c7428a88be1adea75dc7b49ea67287a57ea" :filename "opa-v0.10.3.tar.gz"}
 :build_deps ["karate/bash"]
 :scaffolding "karate/scaffolding-go"
 :bin_dirs ["bin"]
 :exports {"address" "service.address"}
 :prepare (fn [b]
            (let [build (b:join (b.scaffolding.pkg_path b) "build")]
              (b:fix_interpreter (b:glob build "*.sh") "karate/bash" "bin/bash")
              ;; The build's hostname, stamped into the binary, is the Builder's.
              (let [script (b:join build "get-build-hostname.sh")
                    (fixed _) (: (b:read script) :gsub "hostname %-f" "echo \"bldr.karate.company\"")]
                (b:write script fixed))))
 :build (fn [b]
          (b.scaffolding.env b)
          (b:run ["make" "deps" "build" "BUILD_COMMIT=a852671"] {:cwd (b.scaffolding.pkg_path b)}))
 :install (fn [b]
            (b:log "copying binary")
            (b:copy (b:join (b.scaffolding.pkg_path b) (.. "opa_linux_" (b.scaffolding.goarch b)))
                    (b:join b.prefix "bin/opa")))}
