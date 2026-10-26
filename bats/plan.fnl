;; bats, ported from its plan.sh.
{:name "bats"
 :origin "karate"
 :version "0.4.0"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["MIT"]
 :description "Bats is a TAP-compliant testing framework for Bash. It provides a simple way to verify that the UNIX programs you write behave as expected."
 :upstream_url "https://github.com/sstephenson/bats"
 :source {:url "https://github.com/sstephenson/bats/archive/v0.4.0.tar.gz" :sha256 "480d8d64f1681eee78d1002527f3f06e1ac01e173b761bc73d0cf33f4dc1d8d7"}
 :deps ["karate/bash" "karate/coreutils" "karate/sed"]
 :bin_dirs ["bin"]
 :build (fn [b]
          (b:fix_interpreter [(b:join b.src "install.sh")] "karate/coreutils" "bin/env")
          (b:fix_interpreter (b:glob (b:join b.src "'libexec") "*'") "karate/coreutils" "bin/env"))
 :check (fn [b]
          (b:run ["./bin/bats" "--tap" "test"]))
 :install (fn [b]
          (b:run ["./install.sh" b.prefix]))}
