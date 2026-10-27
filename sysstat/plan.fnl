;; sysstat, ported from its plan.sh.
;; sysstat 12.8.0, the latest release on 2026-10-26: 11.5.1's source no longer downloads.
{:name :sysstat
 :origin :karate
 :version :12.8.0
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:GPL-2.0]
 :description "Sysstat and the utilities it provides: iostat, mpstat, pidstat, sar, sa1, sa2 and sadf"
 :upstream_url "http://sebastien.godard.pagesperso-orange.fr/"
 :source {:url "https://sysstat.github.io/sysstat-packages/sysstat-12.8.0.tar.gz"
          :sha256 :4625dfddb04b357bb98341a4a4897c0d939c48ee1b67ae519dcc50a951b62c70}
 :deps [:karate/glibc]
 :build_deps [:karate/make :karate/gcc]
 :bin_dirs [:bin]
 :lib_dirs [:lib]
 :include_dirs [:include]}
