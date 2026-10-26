;; runc, ported from its plan.sh.
;; The source project's plan let scaffolding-go `go get` runc, which took its
;; newest commit; the plan's checksum was never checked. This is the v0.1.1
;; tag its version names, pinned. Its Makefile builds against the dependencies
;; it keeps in Godeps/_workspace, which `go install` outside the Makefile does
;; not see, so the binary make builds is the one installed; the Makefile stamps
;; the commit git reports, which an archive cannot, and that is v0.1.1's.
{:name "runc"
 :origin "karate"
 :version "0.1.1"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["Apache-2.0"]
 :description "CLI tool for spawning and running containers according to the OCI specification"
 :upstream_url "https://www.opencontainers.org/"
 :source {:url "https://github.com/opencontainers/runc/archive/v0.1.1.tar.gz" :sha256 "e59694701625218b26b40a8ab2401ef366a940467c61aa21c71f156ea9778f9e" :filename "runc-v0.1.1.tar.gz"}
 :build_deps ["karate/pkg-config" "karate/libseccomp"]
 :scaffolding "karate/scaffolding-go"
 :bin_dirs ["bin"]
 :build (fn [b]
          (b.scaffolding.env b)
          (b:run ["make" "COMMIT=baf6536d6259209c3edfa2b22237af82942d3dfa"] {:cwd (b.scaffolding.pkg_path b)}))
 :install (fn [b]
            (b:copy (b:join (b.scaffolding.pkg_path b) "runc") (b:join b.prefix "bin/runc")))}
