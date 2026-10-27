;; pngcrush, ported from its plan.sh.
{:name :pngcrush
 :origin :karate
 :version :1.8.13
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:Custom]
 :description "Pngcrush is an optimizer for PNG (Portable Network Graphics) files."
 :upstream_url "https://pmt.sourceforge.io/pngcrush/"
 :source {:url "https://downloads.sourceforge.net/project/pmt/pngcrush/1.8.13/pngcrush-1.8.13.tar.xz"
          :sha256 :8fc18bcbcc65146769241e20f9e21e443b0f4538d581250dce89b1e969a30705}
 :deps [:karate/glibc]
 :build_deps [:karate/make :karate/gcc]
 :bin_dirs [:bin]
 :build (fn [b]
          (b:run [:make]))
 :install (fn [b]
            (b:copy (b:join b.src :pngcrush) (.. b.prefix :/bin/pngcrush))
            (b:chmod (.. b.prefix :/bin/pngcrush) :0755)
            (b:copy (b:join b.src :LICENSE) (.. b.prefix :/share/LICENSE))
            (b:chmod (.. b.prefix :/share/LICENSE) :0644))}
