;; The base tools every build may run without declaring them: a shell, the core utilities, sed,
;; grep, awk, make, patch and the archive tools. doj-plan-build --backline karate/backline adds it
;; as each build's last build dependency, so in an isolated build these are the only tools on
;; PATH besides the plan's own. The list is Habitat's: the bash plan builder's dependencies,
;; which its studio put on every build's PATH, with diffutils and make from its backline and patch.
{:name :backline
 :origin :karate
 :version :1.0.0
 :maintainer "Strip Mall Karate Company"
 :targets [:x86_64-linux]
 :license [:Apache-2.0]
 :description "The base tools every Dojo build may run without declaring them."
 :deps [:karate/bash
        :karate/binutils
        :karate/bzip2
        :karate/coreutils
        :karate/diffutils
        :karate/file
        :karate/findutils
        :karate/gawk
        :karate/grep
        :karate/gzip
        :karate/make
        :karate/patch
        :karate/sed
        :karate/tar
        :karate/unzip
        :karate/wget
        :karate/xz]
 :build (fn [b]
          nil)
 :install (fn [b]
            nil)}
