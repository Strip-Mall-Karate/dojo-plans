;; clens, ported from its plan.sh.
;; clens 0.7.0, the latest release on 2026-10-26.
{:name "clens"
 :origin "karate"
 :version "0.7.0"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["isc"]
 :description "clens is a convenience library to port code to different operating systems. Operating systems traditionally have different enough APIs that porting code is painful. To keep code readable and #ifdef free, clens brings other APIs or missing functions into specific OS focus."
 :upstream_url "https://sourceforge.net/projects/clens/"
 :source {:url "https://downloads.sourceforge.net/project/clens/clens-0.7.0.tar.gz" :sha256 "064ac9954d38633e2cff6b696fd049dedc3e90b79acffbee1a87754bcf604267"}
 :deps ["karate/glibc"]
 :build_deps ["karate/coreutils" "karate/diffutils" "karate/patch" "karate/make" "karate/gcc" "karate/libbsd"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :build (fn [b]
          (b:mkdir (b:join b.src "obj"))
          (b:run ["make" (.. "LOCALBASE=" b.prefix)]))
 :install (fn [b]
          (b:run ["make" (.. "LOCALBASE=" b.prefix) "install"]))}
