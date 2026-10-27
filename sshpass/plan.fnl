;; sshpass, ported from its plan.sh.
{:name :sshpass
 :origin :karate
 :version :1.06
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:GPL-2.0-or-later]
 :description "Non-interactive ssh password auth"
 :upstream_url "https://sourceforge.net/projects/sshpass/"
 :source {:url "https://downloads.sourceforge.net/project/sshpass/sshpass/1.06/sshpass-1.06.tar.gz"
          :sha256 :c6324fcee608b99a58f9870157dfa754837f8c48be3df0f5e2f3accf145dee60
          :filename :sshpass-1.06.tar.gz}
 :build_deps [:karate/make :karate/gcc]
 :bin_dirs [:bin]}
