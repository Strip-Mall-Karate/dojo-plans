;; bats, ported from its plan.sh.
;; bats 1.14.0 (bats-core, the maintained successor of sstephenson/bats), the latest release on 2026-10-26.
{:name "bats"
 :origin "karate"
 :version "1.14.0"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["MIT"]
 :description "Bats is a TAP-compliant testing framework for Bash. It provides a simple way to verify that the UNIX programs you write behave as expected."
 :upstream_url "https://github.com/bats-core/bats-core"
 :source {:url "https://github.com/bats-core/bats-core/archive/refs/tags/v1.14.0.tar.gz" :sha256 "bb537b70b15b732f6d8827dd6578e3d8ce166636ce1f18ea9a074184fcce9177" :filename "bats-core-1.14.0.tar.gz" :dirname "bats-core-1.14.0"}
 :deps ["karate/bash" "karate/coreutils" "karate/sed"]
 :bin_dirs ["bin"]
 :build (fn [b]
          (b:fix_interpreter [(b:join b.src "install.sh") (b:join b.src "bin/bats")] "karate/coreutils" "bin/env")
          (b:fix_interpreter (b:glob (b:join b.src "libexec/bats-core") "*") "karate/coreutils" "bin/env"))
 :check (fn [b]
          (b:run ["./bin/bats" "--tap" "test"]))
 :install (fn [b]
          (b:run ["./install.sh" b.prefix]))}
