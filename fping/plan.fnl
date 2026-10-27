;; fping, ported from its plan.sh.
{:name :fping
 :origin :karate
 :version :4.2
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:custom]
 :description "fping is a program to send ICMP echo probes to network hosts, similar to
ping, but much better performing when pinging multiple hosts. fping has a
long long story: Roland Schemers did publish a first version of it in 1992
and it has established itself since then as a standard tool."
 :upstream_url "http://fping.org/"
 :source {:url "https://github.com/schweikert/fping/archive/v4.2.tar.gz"
          :sha256 :49b0ac77fd67c1ed45c9587ffab0737a3bebcfa5968174329f418732dbf655d4}
 :deps [:karate/glibc]
 :build_deps [:karate/autoconf
              :karate/autogen
              :karate/automake
              :karate/gcc
              :karate/iana-etc
              :karate/make]
 :bin_dirs [:sbin]
 :build (fn [b]
          (b:run [:./autogen.sh])
          (b.default.build b))
 :check (fn [b]
          (b:run [:make :check]))
 :install (fn [b]
            (b.default.install b)
            (b:copy (b:join b.src :COPYING)
                    (.. b.prefix :/share/licenses/license.txt))
            (b:chmod (.. b.prefix :/share/licenses/license.txt) :644))}
