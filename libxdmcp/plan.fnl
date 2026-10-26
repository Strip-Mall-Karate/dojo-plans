;; libxdmcp, ported from its plan.sh.
{:name "libxdmcp"
 :origin "karate"
 :version "1.1.2"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["MIT"]
 :description "X11 Display Manager Control Protocol library"
 :upstream_url "https://www.x.org/"
 :source {:url "https://www.x.org/releases/individual/lib/libXdmcp-1.1.2.tar.bz2" :sha256 "81fe09867918fff258296e1e1e159f0dc639cb30d201c53519f25ab73af4e4e2" :dirname "libXdmcp-1.1.2"}
 :deps ["karate/glibc"]
 :build_deps ["karate/gcc" "karate/make" "karate/pkg-config" "karate/xproto"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :pconfig_dirs ["lib/pkgconfig"]
 :check (fn [b]
          (b:run ["make" "check"]))}
