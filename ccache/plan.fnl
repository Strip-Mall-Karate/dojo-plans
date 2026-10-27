;; ccache, ported from its plan.sh.
{:name :ccache
 :origin :karate
 :version :3.5
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:GPL-3.0]
 :description "ccache is a compiler cache. It speeds up recompilation by caching previous compilations and detecting when the same compilation is being done again."
 :upstream_url "https://ccache.samba.org/"
 :source {:url "https://www.samba.org/ftp/ccache/ccache-3.5.tar.gz"
          :sha256 :8094f9bc186be4c9db9b480eeac280926bd44039502d1e596f45371b05a85918}
 :deps [:karate/glibc :karate/zlib]
 :build_deps [:karate/gcc :karate/make :karate/diffutils :karate/which]
 :bin_dirs [:bin]
 :check (fn [b]
          (b:run [:make :test]))}
